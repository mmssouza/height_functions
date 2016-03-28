#!/usr/bin/python -u

import sys
import getopt
import cPickle
import optimize
import oct2py
from multiprocessing import Pool,cpu_count
import numpy as np
import amostra_base
from functools import partial
from time import time

mt = 1
dataset = ""
fout = ""
dim = -1
NS = 5

beta = 0.0001
alpha = 1

try:                                
 opts,args = getopt.getopt(sys.argv[1:], "o:d:", ["mt=","dim=","output=","dataset="])
except getopt.GetoptError:           
 print "Error getopt"                          
 sys.exit(2)          
 
for opt,arg in opts:
 if opt == "--mt":
  mt = int(arg)
 elif opt in ("-o","--output"):
  fout = arg
 elif opt in ("-d","--dataset"):
  dataset = arg
 elif opt == "--dim":
  dim = int(arg)
  
conf = [float(i) for i in args]

if dataset == "" or fout == "" or len(conf) != 4 or dim <= 0:
 print "Error getopt" 
 sys.exit(2)

algo = "sa"
N,M = 2,1

Head = {'algo':algo,'conf':"T0,alpha,P,L = {0},{1},{2},{3}".format(conf[0],conf[1],conf[2],conf[3]),'dim':dim,"dataset":dataset}

if __name__ == '__main__':
 from pdist_mt import silhouette,set_param
 
 Y,names = [],[]
 with open(dataset+"/"+"classes.txt","r") as f:
  cl = cPickle.load(f)
  nm = amostra_base.amostra(dataset,NS)
  for k in nm[0:12]:
   Y.append(cl[k])
   names.append(dataset+"/"+k)
 
 def fy(n,nc):
  oc = oct2py.Oct2Py()
  oc.addpath("common_HF")
  oc.eval("pkg load statistics;")
  a = oc.batch_hf(n,nc)
  oc.exit()
  return a
 
 def cost_func(args):  
  tt = time()
  set_param(beta,alpha)
  N = len(names)
  Ncpu = cpu_count()
  Nc =  int(args[0])
  k = int(args[1])

  print "Avaliando funcao custo para N = {0}, Nc = {1} e k = {2}".format(N,Nc,k) 

  limits_hi= np.linspace(2*N/Ncpu,N,Ncpu/2).astype(int)
  limits_lo = np.hstack((0,limits_hi[0:limits_hi.shape[0]-1]))
  idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo,limits_hi)]
  l = [np.array(names)[i].tolist() for i in idx]
  print "Calculando hf"
  p = Pool(processes = Ncpu/2) 
  ff = partial(fy,nc = Nc)
  res = p.map(ff,l)
  p.close()
  a = []
  
  for i in res:
   a = a+i
  
  Fl = []

  print "Suavizando"
 
  if k > 1:
   limits_lo = np.arange(0,Nc,k)
   limits_hi= np.arange(k,Nc,k)
   idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo[0:len(limits_lo)-1],limits_hi)]
   for mt in a:
    F = np.array([[k[i].mean() for i in idx] for k in mt.T])
    Fl.append(F)
  else:
   for mt in a:
    Fl.append(mt.T)  

  print "Calculando Silhouette"
  cost = float(np.median(1. - silhouette(Fl,np.array(Y)-1,Nthreads = Ncpu)))
  print
  print "tempo total: {0} seconds".format(time() - tt)
  print "cost = {0}".format(cost)
  return cost
 
 with open(fout,"wb") as f:
  cPickle.dump(Head,f)
  cPickle.dump((N,M),f)
  for j in range(M):
   w = optimize.sim_ann(cost_func,conf[0],conf[1],conf[2],conf[3])
   for i in range(N):
    w.run()
    print i,w.s,w.fit
    cPickle.dump([i,w.fit,w.s],f)
   cPickle.dump(w.hall_of_fame[0],f)
 
