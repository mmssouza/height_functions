#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import cPickle
import numpy as np
from fastdtw import fastdtw
from time import time
import descritores as desc

def cost(x,y):
  M = len(x)
  c = 0
  for k in np.arange(M):
   c = c + np.abs(x[k] - y[k])/float(min(k+1, M-k+1))**alpha
  return c

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
 Fl = [np.array([desc.dii(sys.argv[1] + k,raio = r,nc = nc,method = "octave") for r in raio]) for k in names]
 print time() - tt

 print "Calculando matriz de distancias"

 tt = time()

 md = pdist(Fl)

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

