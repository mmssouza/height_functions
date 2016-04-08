#!/usr/bin/python

import sys
import cPickle
import numpy as np
import fastdtw
from time import time
from  pdist_mt import pdist_mt
import descritores as desc

if __name__ == '__main__':
 # Pontos do contorno
 nc = 100
 #Suavizacao
 raio = np.array([8,16,24,32,40,48])
 # Calculo da distancia
 beta = 0.0001
 # Calculo da distancia
 alpha = 1
 radius = 20
 
 def cost(x,y):
  M = len(x)
  c = 0
  for k in np.arange(M):
   c = c + np.abs(x[k] - y[k])/float(min(k+1, M-k+1))**alpha
  return c

 def dist(X,Y):
  CX = np.std(X,axis = 1).mean()
  CY = np.std(Y,axis = 1).mean() 
  return fastdtw(X,Y,dist = cost,radius = radius)[0]/(CX + CY + beta)
  
 def pdist(X):
  N = len(X)
  p = np.zeros((N,N))
  for i in np.arange(N):
   for j in np.arange(i,N):
    if i != j:
     p[i,j] = dist(X[i],X[j])
   print i
  return p
   
 db = cPickle.load(open(sys.argv[1]+"classes.txt"))
 names = [sys.argv[1] + i for i in db.keys()]
 cl = db.values()
 N = len(cl)
 
 print "Calculando descritores"
 
 tt = time()
 Fl = [np.array([desc.dii(k,raio = r,nc = nc,method = "octave") for r in raio] for k in names]
 print time() - tt

 print "Calculando matriz de distancias"

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



