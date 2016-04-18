#!/usr/bin/python -u

import sys
import os.path
import getopt
import cPickle
import optimize
import oct2py
from multiprocessing import Pool,cpu_count
import numpy as np
import amostra_base
from functools import partial
from time import time

def fy(n,nc):
  oc = oct2py.Oct2Py()
  oc.addpath("common_HF")
  oc.eval("pkg load statistics;")
  a = oc.batch_hf(n,nc)
  oc.exit()
  return a
 
if __name__ == '__main__':
 mt = cpu_count()
 dataset = ""
 fout = ""
 dim = -1
 NS = 3
 
 try:                                
  opts,args = getopt.getopt(sys.argv[1:], "o:d:", ["mt=","dim=","output=","dataset="])
 except getopt.GetoptError:           
  print "Error getopt"                          
  sys.exit(2)          
 
 for opt,arg in opts:
  if opt == "--mt":
   setattr(sys.modules[__name__],"mt",int(arg))
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
 has_dump_file = False
 if os.path.isfile("dump_optimize_sa.pkl"):
  has_dump_file = True
  dump_fd = open("dump_optimize_sa.pkl","r")
  nn = cPickle.load(dump_fd)
  mm = cPickle.load(dump_fd)
 else:
  nn = 0
  mm = 0  

 N,M = 200,3

 Head = {'algo':algo,'conf':"T0,alpha,P,L = {0},{1},{2},{3}".format(conf[0],conf[1],conf[2],conf[3]),'dim':dim,"dataset":dataset}
 
 Y,names = [],[]
 with open(dataset+"/"+"classes.txt","r") as f:
  cl = cPickle.load(f)
  nm = amostra_base.amostra(dataset,cl,NS)
  for k in nm:
   Y.append(cl[k])
   names.append(dataset+"/"+k)

# def cost_test(args):
#  Nc =  args[0]
#  k = args[1]
#  beta = args[2]
#  alpha = args[3]
#  radius = args[4]
#  print "{0} {1} {2} {3} {4}".format(Nc,k,round(beta,5),round(alpha,3),radius) 

# return 0.1
 
 def silhouette(X, cIDX):
    """
    Computes the silhouette score for each instance of a clustered dataset,
    which is defined as:
        s(i) = (b(i)-a(i)) / max{a(i),b(i)}
    with:
        -1 <= s(i) <= 1

    Args:
        X    : A M-by-N array of M observations in N dimensions
        cIDX : array of len M containing cluster indices (starting from zero)

    Returns:
        s    : silhouette value of each observation
    """

    N = len(X)              # number of instances
    K = len(np.unique(cIDX))    # number of clusters

    # compute pairwise distance matrix
    #D = squareform(pdist(X,metric = distance))
    D = X
 
    # indices belonging to each cluster
    kIndices = [np.flatnonzero(cIDX==k) for k in range(K)]

    # compute a,b,s for each instance
    a = np.zeros(N)
    b = np.zeros(N)
    for i in range(N):
        # instances in same cluster other than instance itself
        a[i] = np.mean( [D[i][ind] for ind in kIndices[cIDX[i]] if ind!=i] )
        # instances in other clusters, one cluster at a time
        b[i] = np.min( [np.mean(D[i][ind]) 
                        for k,ind in enumerate(kIndices) if cIDX[i]!=k] )
    s = (b-a)/np.maximum(a,b)

    return s
 
 def cost_func(args):  
  tt = time() 
  N = len(names)
  Ncpu = getattr(sys.modules[__name__],"mt")
  Nc =  int(round(args[0]))
  k = int(round(args[1]))
  #thre = args[2]
  num_start = int(round(args[2]))
  #search_step = int(round(args[4]))
  thre = 0.
  search_step = 1
  #print "Avaliando funcao custo para N = {0}, Ncpu = {1}, Nc = {2}, k = {3}, thre = {4}, ns = {5}, ss = {6}".format(N,Ncpu,Nc,k,thre,num_start,search_step) 

  limits_hi= np.linspace(2*N/Ncpu,N,Ncpu/2).astype(int)
  limits_lo = np.hstack((0,limits_hi[0:limits_hi.shape[0]-1]))
  idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo,limits_hi)]
  l = [np.array(names)[i].tolist() for i in idx]
  #print "Calculando hf"
  p = Pool(processes = Ncpu/2) 
  ff = partial(getattr(sys.modules[__name__],"fy"),nc = Nc)
  res = p.map(ff,l)
  p.close()
  a = []
  
  for i in res:
   a = a+i
  Fl = []

  #print "Suavizando"
 
  if k > 1:
   limits_lo = np.arange(0,Nc-3,k)
   limits_hi= np.arange(k,Nc-3,k)
   idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo[0:len(limits_lo)-1],limits_hi)]
   for mt in a:
    F = np.array([[k[i].mean() for i in idx] for k in mt.T])
    Fl.append(F.T)
  else:
   for mt in a:
    Fl.append(mt)
  #print "Calculando md"
  oc = oct2py.Oct2Py()
  oc.addpath("common_HF")  
  md = oc.pdist2(Fl,thre,num_start,search_step)
  oc.exit()
  #print "Calculando Silhouette"
  cost = float(np.median(1. - silhouette(md,np.array(Y)-1)))
  #print
  #print "tempo total: {0} seconds".format(time() - tt)
  #print "cost = {0}".format(cost)
  sys.stdout.write(".")
  #print "tempo total: {0} seconds".format(time() - tt)
  #print "cost = {0}".format(cost)
  return cost

 with open(fout,"ab",0) as f:
  if not has_dump_file:
   cPickle.dump(Head,f)
   cPickle.dump((N,M),f)
  for j in range(mm,M):
   w = optimize.sim_ann(cost_func,conf[0],conf[1],conf[2],conf[3])
   for i in range(nn,N):
    w.run()
    dump_fd = open("dump_optimize_sa.pkl","wb")
    cPickle.dump(i+1,dump_fd)
    cPickle.dump(j,dump_fd)
    dump_fd.close()
    print i,w.s,w.fit
    cPickle.dump([i,w.fit,w.s],f)
   os.remove("dump_sim_ann.pkl") 
   cPickle.dump(w.hall_of_fame[0],f)
   nn = 0
 
