# -*- coding: utf-8 -*-
# descritores : módulo que implementa o cálculo de assinaturas e descritores de imagens

import numpy as np
import cv,cv2
from scipy.interpolate import interp1d 
from scipy.spatial.distance import pdist,squareform
from math import sqrt,acos
from oct2py import Oct2Py
import atexit

oc = Oct2Py()
atexit.register(oc.exit)

class contour_base:
 '''Represents an binary image contour as a complex discrete signal. 
   Some calculation methods are provided to compute contour 1st derivative, 2nd derivatives and perimeter.
   The signal variable (self.c) is represented as a single dimensional ndarray of complex.  
   This class is interable and callable so, interation over objects results in sequential access to each signal variable element. Furthermore, calling the object as a function yields as return value te signal variable.
 
 '''

 def __init__(self,fn,nc = 256,method = 'cv'):
  self.__i = 0
  if method == 'octave':
   if type(fn) is str:
    im = oc.imread(fn)
    oc.addpath("common_HF") 
    s = oc.extract_longest_cont(im,nc)
    self.c = np.array([complex(i[0],i[1]) for i in s])
   else:
    self.c = fn
  else:	
   if type(fn) is str:
    im = cv.LoadImage(fn,cv.CV_LOAD_IMAGE_GRAYSCALE)
    s = cv.FindContours(im,cv.CreateMemStorage(),cv.CV_RETR_LIST,cv.CV_CHAIN_APPROX_NONE) 
    self.c = np.array([complex(i[1],i[0]) for i in s])
   elif (type(fn) is np.ndarray):
    self.c = fn
   elif (type(fn) is cv.iplimage):
    s = cv.FindContours(fn,cv.CreateMemStorage(),cv.CV_RETR_LIST,cv.CV_CHAIN_APPROX_NONE) 
    self.c = np.array([complex(i[1],i[0]) for i in s])
  N = self.c.size
  self.freq = np.fft.fftfreq(N,1./float(N))

  self.ftc = np.fft.fft(self.c)

  if isinstance(self,contour_base):
   self.calc_derivatives()
 
 def calc_derivatives(self):
   ftcd = np.complex(0,1) * 2 * np.pi * self.freq * self.ftc
   ftcdd = - (2 * np.pi * self.freq)**2 * self.ftc 
   self.cd = np.fft.ifft(ftcd)
   self.cdd = np.fft.ifft(ftcdd)

 def first_deriv(self): 
  '''Return the contour signal 1st derivative'''
  return self.cd

 def second_deriv(self): 
  '''Return the contour signal 2nd derivative'''
  return self.cdd

 def perimeter(self): 
  '''Calculate and return the contour perimeter'''
  return (2*np.pi*np.sum(np.abs(self.cd))/float(self.cd.size))

 def __iter__(self): return self

 def next(self):

  if self.__i > self.c.size-1:
   self.__i = 0
   raise StopIteration
  else:
   self.__i += 1
   return self.c[self.__i-1]
 
 def __call__(self): return self.c

class contour(contour_base):
  '''Like contour_base except that, prior to derive a complex signal representation, smooths the image contour using a Gaussian kernel. The kernel parameter (gaussian standard deviation) is the second constructor parameter. See also contour_base.'''

  # Gaussian smoothing function 
  def __G(self,s):
    return (1/(s*(2*np.pi)**0.5))*np.exp(-self.freq**2/(2*s**2))
  
  def __init__(self,fn,sigma=None,nc = 256,method = 'cv'):
   contour_base.__init__(self,fn,nc = nc,method = method)
   if sigma is not None:
    E = np.sum(self.ftc * self.ftc.conjugate())
    self.ftc = self.ftc * self.__G(sigma)
    Eg  = np.sum(self.ftc * self.ftc.conjugate())
    k = sqrt(abs(E/Eg))
    self.c = np.fft.ifft(self.ftc)*k
    self.calc_derivatives()
    self.cd = self.cd * k
    self.cdd = self.cdd * k
     

# classe curvatura : calcula a curvatura de um contorno para vários níveis de suavização
# Parâmetros do Construtor:   def __init__(self,fn = None,sigma_range = np.linspace(2,30,10)) 
#  fn : Pode ser o nome de um arquivo de imagem (string) que contenha uma forma binária ou um vetor (ndarray) de valores das
# coordenadas do contorno de uma forma (representação complexa x+j.y). 
# No primeiro caso os contornos são extraídos através da função cv.FindContours() da biblioteca Opencv
#  sigma_range :  vetor (ndarray) que contém os valores que serão utilizados como desvio padrão para o FPB Gaussiana. 
# que filtra os contorno antes do cálculo da curvatura.
 #  when zero no filtering is applied to contour

class curvatura:
  '''For a given binary image calculates and yields a family of curvature signals represented in a two dimensional ndarray structure; each row corresponds to the curvature signal derived from the smoothed contour for a certain smooth level.'''

  def __Calcula_Curvograma(self,fn,nc = 256,method = 'cv'):
   if type(fn) is contour:
    z = fn
   else:
    z = contour(fn,nc = nc,method = method)
   caux = [contour(z(),s) for s in self.sigmas]
   caux.append(z)
   self.contours = np.array(caux)
   self.t = np.linspace(0,1,z().size)
   self.curvs = np.ndarray((self.sigmas.size+1,self.t.size),dtype = "float")
  
   for c,i in zip(self.contours,np.arange(self.contours.size)):
    # Calcula curvatura para varias escalas de suavização do contorno da forma
     curv = c.first_deriv() * np.conjugate(c.second_deriv())
     curv = - curv.imag
     curv = curv/(np.abs(c.first_deriv())**3)
     # Array bidimensional curvs = Curvature Function k(sigma,t) 
     self.curvs[i] = curv 
 
  # Contructor 
  def __init__(self,fn = None,sigma_range = np.linspace(2,30,20),nc = 256,method = 'cv'):
   # Extrai contorno da imagem
   self.sigmas = sigma_range
   self.__Calcula_Curvograma(fn,nc = nc,method = method)

 # Function to compute curvature
 # It is called into class constructor
  def __call__(self,idx = 0,t= None):
    if t is None:
     __curv = self.curvs[idx]
    elif (type(t) is np.ndarray):
     __curv = interp1d(self.t,y = self.curvs[idx],kind='quadratic')
     return(__curv(t))
    else:
      __curv = self.curvs[idx]

    return(__curv)
   
class bendenergy:
 ''' For a given binary image, computes the multiscale contour curvature bend energy descriptor'''
 
 def __init__(self,fn,scale,nc = 256,method = 'cv'):
  self.__i = 0
  k = curvatura(fn,scale[::-1],nc = nc,method = method)
  # p = perimetro do contorno nao suavisado
  p = k.contours[-1].perimeter() 
  self.phi  = np.array([(p**2)*np.mean(k(i)**2) for i in np.arange(0,scale.size)])

 def __call__(self): return self.phi
 
 def __iter__(self): return self

 def next(self):

   if self.__i > self.phi.size-1:
    self.__i = 0
    raise StopIteration
   else:
    self.__i += 1
    return self.phi[self.__i-1]

# Area integral invariant signature
def aii(name,r,white_bg = False):
 im = cv2.imread(name,0)
# Caso imagem seja fundo branco
 if white_bg:
  im = cv2.bitwise_not(im)
  
 im_aux = np.zeros((im.shape[0]+4*r,im.shape[1]+4*r),dtype=im.dtype)
 im_aux[2*r:im_aux.shape[0]-2*r,2*r:im_aux.shape[1]-2*r] = im
 im = im_aux.copy()
 cnt,h = cv2.findContours(im_aux,cv2.RETR_LIST,cv2.CHAIN_APPROX_NONE)
 l = []
 for a in cnt[0]:
  c = a[0][0],a[0][1]
  aux = np.zeros(im.shape,dtype = im.dtype)
  cv2.circle(aux,c,r,255,-1)
  aux2 = cv2.bitwise_and(aux,im)
  cnt2,h = cv2.findContours(aux2,cv2.RETR_LIST,cv2.CHAIN_APPROX_NONE)
  area = 0
  for c in cnt2:
   area = area + cv2.contourArea(c)
  l.append(area)

 return np.array(l)

#class areaintegralinvariant:

# def __init__(self,fn,raio,sigma,n):
#  self.r = raio
#  t = np.linspace(0,1,n)
#  k = curvatura(fn,np.linspace(sigma,sigma,1))
#  self.ir = np.ndarray((t.size),dtype="double")
#  self.ir = 2*self.r**2*np.arccos(self.r*k(0,t)/2)
 
# def __call__(self): return (self.ir)

# Distance integral invariant
def dii(fn,raio,nc = 256,method = 'cv'):
  c = contour_base(fn,nc = nc,method = method)
  aux = np.vstack([c.c.real,c.c.imag]).T
  d = squareform(pdist(aux))
  r = raio*c.perimeter()/(2*np.pi)
  res = np.array([x[np.nonzero(x <= r)].sum() for x in d])/float(r)
  return res - res.mean()
  
# Centroid distance signature
def cd(fn,nc = 256,method = 'cv'):
  img_c = contour_base(fn,nc = nc,method = method)
  # Calcula distância ao centróide
  dc = np.abs((img_c()-img_c().mean()))
  # m = maior distancia do contorno ao centroide
  m = np.max(dc)
  return dc/m

# Angle sequence shape signature
class ass:

 def __init__(self,fn,raio,nc = 256,method = 'cv'):
  r = raio
  cont = contour_base(fn,nc = nc,method = method).c
  N = cont.shape[0]
  low = cont[0:r].copy()
  high = cont[N-r:N].copy()
  cont = np.hstack((high,cont,low))
  a = []
  for i in np.arange(r,N+r):
   v1 = cont[i] - cont[i-r]
   v2 = cont[i+r] - cont[i]
   cc = (v1*v2).real/float(abs(v1)*abs(v2))
   if cc > 1.0:
    cc = 1.0
   if cc < -1.0:
    cc = -1.0
   angle = acos(cc)
   # angle = np.floor(angle * 180./np.pi)
   # if angle in np.arange(0.,5.):
   #  angle = 0
   # elif angle in np.arange(5.,10.):
   #  angle = 1
   # elif angle in np.arange(10.,20.):
   #  angle = 2
   # elif angle in np.arange(20.,40.):
   #  angle = 3
   # elif angle in np.arange(40.,60.):
   #  angle = 4
   # elif angle in np.arange(60.,80.):
   #  angle = 5
   # elif angle in np.arange(80.,95.):
   #  angle = 6
   # elif angle in np.arange(95.,135.):
   #  angle = 7
   # elif angle in np.arange(135.,140.):
   #  angle = 8
   # elif angle in np.arange(140.,175.):
   #  angle = 9
   # elif angle in np.arange(175.,185.):
   #  angle = 10
   a.append(angle)

  self.sig = np.array(a)

# Triangle area signature
class TAS:
 def TAN(self,c,ts):
  low = c[0:ts].copy()
  high = c[self.N-ts:self.N].copy()
  c = np.hstack((high,c,low))
  
  ta = []
  for i in np.arange(ts,self.N+ts):
   a = 0.5*(c[i].real*(c[i+ts]-c[i-ts]).imag + c[i+ts].real*(c[i-ts]-c[i]).imag + c[i-ts].real*(c[i]-c[i+ts]).imag)
   ta.append(a)
  ta = np.array(ta)
  ta = ta/np.abs(ta).max()
  return ta
  
 def __init__(self,fn,nc = 256, method = 'cv'):
  cont = contour_base(fn,nc = nc,method = method).c
  self.N = cont.shape[0]
  Ts = np.floor((self.N-1)/2)
  t = []
  for ts in np.arange(1,Ts):
   t.append(self.TAN(cont,ts))
  
  acum = t[0] 
  for a in t[1:]:
   acum = acum + a
  self.sig = np.array(acum)/float(Ts)

def fTAS(fn,nc='256'):
   im = oc.imread(fn)
   mc  = oc.extract_longest_cont(im,nc)
   vtas =oc.ftas(mc.T())
   return vtas.T()
