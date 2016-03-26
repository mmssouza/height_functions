#!/usr/bin/python

import sys
import oct2py 
import cPickle
import numpy as np


def cost(x,y):
 M = x.shape[0]
 c = 0
 for k in np.arange(M):
  c = c + np.abs(x[k] - y[k])/float(min(k+1, M-k+1))
 return c

def dtw(x, y):
    """
    Computes Dynamic Time Warping (DTW) of two sequences.

    :param array x: N1*M array
    :param array y: N2*M array
    :param func dist: distance used as cost measure

    Returns the minimum distance, the cost matrix, the accumulated cost matrix, and the wrap path.
    """
    assert len(x)
    assert len(y)
    r, c = len(x), len(y)
    D0 = np.zeros((r + 1, c + 1))
    D0[0, 1:] = np.inf
    D0[1:, 0] = np.inf
    D1 = D0[1:, 1:] # view
    for i in range(r):
        for j in range(c):
            D1[i, j] = cost(x[i], y[j])
    C = D1.copy()
    for i in range(r):
        for j in range(c):
            D1[i, j] += min(D0[i, j], D0[i, j+1], D0[i+1, j])
    if len(x)==1:
        path = np.zeros(len(y)), range(len(y))
    elif len(y) == 1:
        path = range(len(x)), np.zeros(len(x))
    else:
        path = _traceback(D0)
    return D1[-1, -1] / sum(D1.shape), C, D1, path

def _traceback(D):
    i, j = np.array(D.shape) - 2
    p, q = [i], [j]
    while ((i > 0) or (j > 0)):
        tb = np.argmin((D[i, j], D[i, j+1], D[i+1, j]))
        if (tb == 0):
            i -= 1
            j -= 1
        elif (tb == 1):
            i -= 1
        else: # (tb == 2):
            j -= 1
        p.insert(0, i)
        q.insert(0, j)
    return np.array(p), np.array(q)

def dist(X,Y,beta):
 CX = np.std(X,axis = 1).mean()
 CY = np.std(Y,axis = 1).mean() 
 return  dtw(X,Y)[0]/(CX + CY + beta)

nc = 100
k = 4
beta = 0.0001

db = cPickle.load(open(sys.argv[1]+"classes.txt"))
idx = np.where(np.array(db.values()) == 1)
names = db.keys()
cl = db.values()
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

for i in np.arange(len(Fl)):
 for j in np.arange(i,len(Fl)):
  dd = dist(Fl[i],Fl[j],beta)
  print i,j,dd
  md[i,j] = dd

md = md + md.T

print "Calculando Bulls-eye"
# Acumulador para contabilizar desempenho do experimento
tt = 0.
Nretr = 40
 #print "Calculando bull eye score"
for i in np.arange(Nobj):
  idx = np.argsort(md[i])
  classe_retrs = (cl[idx])[0:Nretr]
  n = np.nonzero(np.array(classe_retrs) == cl[i])
  tt = tt + float(n[0].size)
    
# Bull eye
print 20*1400,tt
print tt/float(1400*20)  



