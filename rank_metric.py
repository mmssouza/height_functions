#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import cPickle
import numpy as np
from scipy.stats import norm
from fastdtw import fastdtw
from time import time
import descritores as desc
from pdist_mt import pdist_mt,set_param

if __name__ == '__main__':
 
 nc = 100
 raio = np.array([0.025,0.05,0.1,0.15,0.25,0.5])
 # Parâmetros da distância
 beta = 0.001
 radius = 40
 sigma = .25

 def smooth(x,s):
  N = len(x)
  mean = N/2
  t = np.arange(N)
  xx = np.hstack((x,x,x))
  xs = np.convolve(xx,norm(mean,s).pdf(t),'same')[N:2*N]
  return xs

 def dist(X,Y):
  CX = np.std(X,axis = 0)
  CY = np.std(Y,axis = 0)
  M = len(raio)
  c = 0
  for i in np.arange(M): 
   c = c + fastdtw(X[i],Y[i],radius = radius)[0]/(CX[i] + CY[i] + beta)
  return c

 def pdist(X):
  N = len(X)
  p = np.zeros((N,N))
  for i in np.arange(N):
   for j in np.arange(i,N):
    if i != j:
     p[i,j] = dist(X[i],X[j])
   print i
  return p+p.T
   
 db = cPickle.load(open(sys.argv[1]+"classes.txt"))
 names = [i for i in db.keys()]
 cl = db.values()
 N = len(cl)
 # Total de classes
 Nclasses = max(cl)
 # Número de recuperações para base balanceada
 Nretr = N/Nclasses
 print "Calculando descritores"
 
 tt = time()
 Fl = [np.array([smooth(desc.dii(sys.argv[1] + k,raio = r,nc = nc,method = "octave"),sigma) for r in raio]) for k in names]
 print time() - tt

 print "Calculando matriz de distancias"

 #tt = time()
 #md = pdist(Fl)
 #print time() - tt

 set_param(b = beta, r = radius)
 tt = time()
 md = pdist_mt(Fl,8)
 print time() - tt
 
 l = np.zeros((Nclasses,Nretr),dtype = int)

 for i,nome in zip(np.arange(N),names):
# Para cada linha de md estabelece rank de recuperacao
# O primeiro elemento de cada linha corresponde a forma modelo
# Obtem a classe dos objetos recuperados pelo ordem crescente de distancia
  idx = np.argsort(md[i])
 # pega classes a qual pertencem o primeiro padrao e as imagens recuperadas
  classe_padrao = db[nome]
  name_retr = np.array(names)[idx] 
  aux = np.array([db[j] for j in name_retr])
  classe_retrs = aux[0:Nretr]
  n = np.nonzero(classe_retrs == classe_padrao)
  for i in n[0]:
   l[classe_padrao-1,i] = l[classe_padrao-1,i] + 1 

 v = np.array([l[:,i].sum() for i in np.arange(Nretr)])

 print l
 print v
 print ((v - 99.)**2).sum()/v.shape[0]

