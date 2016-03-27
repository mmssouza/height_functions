#!/usr/bin/python

import sys
import oct2py 
import cPickle
import numpy as np
import fastdtw
import dtw
from functools import partial

def cost(x,y):
 M = len(x)
 c = 0
 for k in np.arange(M):
  c = c + np.abs(x[k] - y[k])/float(min(k+1, M-k+1))
 return c

def dist(X,Y,beta,metric = dtw.dtw):
 CX = np.std(X,axis = 1).mean()
 CY = np.std(Y,axis = 1).mean() 
 return  metric(X,Y,dist = cost)[0]/(CX + CY + beta)

nc = 100
k = 4
beta = 0.0001

db = cPickle.load(open(sys.argv[1]+"classes.txt"))
#idx = np.where(np.array(db.values()) == 1)
names = db.keys()[0:5]
cl = db.values()[0:5]
N = len(cl)
print N

print "Calculando descritores"
oc = oct2py.Oct2Py()
oc.addpath("common_HF")
oc.eval("pkg load statistics;")
a,b = oc.batch_hf(names,nc)

limits_lo = np.arange(0,nc,k)
limits_hi= np.arange(k,nc,k)

idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo[0:len(limits_lo)-1],limits_hi)]

Fl = []

print "Suavizando"

for mt in a:
 F = np.array([[k[i].mean() for i in idx] for k in mt.T])
 Fl.append(F)

print "Calculando matriz de distancias"
md = np.zeros((N,N))
mf = np.zeros((N,N))

fastdtw = partial(fastdtw.fastdtw,radius = 20)
for i in np.arange(len(Fl)):
 for j in np.arange(i,len(Fl)):
  dd = dist(Fl[i],Fl[j],beta,metric = dtw.dtw)
  df = dist(Fl[i],Fl[j],beta,metric = fastdtw)
  print i,j,dd,df
  md[i,j] = dd
  mf[i,j] = df

md = md + md.T
mf = mf + mf.T
print md,mf
exit(0)

print "Calculando Bulls-eye"
# Acumulador para contabilizar desempenho do experimento
tt = 0.
Nretr = 40
 #print "Calculando bull eye score"
for i in np.arange(len(md)):
  idx = np.argsort(md[i])
  classe_retrs = (cl[idx])[0:Nretr]
  n = np.nonzero(np.array(classe_retrs) == cl[i])
  tt = tt + float(n[0].size)
    
# Bull eye
print 20*1400,tt
print tt/float(1400*20)  



