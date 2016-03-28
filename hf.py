#!/usr/bin/python

import sys
import oct2py 
import cPickle
import numpy as np
import fastdtw
from functools import partial
from time import time
from multiprocessing import Pool,cpu_count
from  pdist_mt import pdist_mt

#def cost(x,y):
# M = len(x)
# c = 0
# for k in np.arange(M):
#  c = c + np.abs(x[k] - y[k])/float(min(k+1, M-k+1))
# return c

#def dist(X,Y,beta):
# CX = np.std(X,axis = 1).mean()
# CY = np.std(Y,axis = 1).mean() 
# return  fastdtw.fastdtw(X,Y,dist = cost,radius = 5)[0]/(CX + CY + beta)

def f(n):
 oc = oct2py.Oct2Py()
 oc.addpath("common_HF")
 oc.eval("pkg load statistics;")
 a = oc.batch_hf(n,nc)
 oc.exit()
 return a

# Pontos do contorno
nc = 100
#Suavizacao
k = 4
# Calculo da distancia
beta = 0.0001
# Calculo da distancia
alpha = 1

if __name__ == '__main__':

 db = cPickle.load(open(sys.argv[1]+"classes.txt"))
 names = [sys.argv[1] + i for i in db.keys()]
 cl = db.values()
 N = len(cl)
 #tt =time()
 print "Calculando descritores"
 #oc = oct2py.Oct2Py()
 #oc.addpath("common_HF")
 #oc.eval("pkg load statistics;")
 #a,b = oc.batch_hf(names,nc)
 #oc.exit()
 #print time() - tt

 tt = time()

 Ncpu = cpu_count()/2

 limits_hi= np.linspace(N/Ncpu,N,Ncpu).astype(int)
 limits_lo = np.hstack((0,limits_hi[0:limits_hi.shape[0]-1]))
 idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo,limits_hi)]

 l = [np.array(names)[i].tolist() for i in idx]

 p = Pool(processes = Ncpu)
 res = p.map(f,l)
 p.close()
 a = []
 for i in res:
  a = a + i

 print time() - tt

 limits_lo = np.arange(0,nc,k)
 limits_hi= np.arange(k,nc,k)
 idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo[0:len(limits_lo)-1],limits_hi)]

 Fl = []

 print "Suavizando"

 for mt in a:
  F = np.array([[k[i].mean() for i in idx] for k in mt.T])
  Fl.append(F)

 print "Calculando matriz de distancias"

# tt = time()
# md = np.zeros((N,N))

# for i in np.arange(len(Fl)):
#  for j in np.arange(i,len(Fl)):
#   md[i,j] = dist(Fl[i],Fl[j],beta)
   
# md = md + md.T
# print md
# print time() - tt

 tt = time()

 md = pdist_mt(Fl)

 print time() - tt

 print "Calculando Bulls-eye"
# Acumulador para contabilizar desempenho do experimento
 tt = 0.
 Nretr = 40
 for i in np.arange(len(md)):
  idx = np.argsort(md[i])
  classe_retrs = (cl[idx])[0:Nretr]
  n = np.nonzero(np.array(classe_retrs) == cl[i])
  tt = tt + float(n[0].size)
    
# Bull eye
 print 20*1400,tt
print tt/float(1400*20)  



