#!/usr/bin/python -u
# -*- coding: utf-8 -*-
import sys
import getopt
import cPickle
import optimize
import descritores as desc
from scipy.stats import norm
from multiprocessing import cpu_count
from pdist_mt import pdist_mt,set_param
import numpy as np
#import amostra_base
from time import time
 
if __name__ == '__main__':

 def smooth(x,s):
  N = len(x)
  return np.convolve(np.hstack((x,x,x)),norm(N/2,s).pdf(np.arange(N)),'same')[N:2*N]
  
 mt = cpu_count()
 # Pontos do contorno
 nc = 32
 # Parâmetros da distância
 beta = 0.001
 radius = 35
 set_param(beta,radius)
 dataset = ""
 fout = ""
 dim = -1
 # Amostras/classe
 NS = 11
 Nclasses = 9
 Nretr = 11
 
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
   optimize.set_dim(dim)
   print optimize.Dim
  
  
 conf = [float(i) for i in args]

 if dataset == "" or fout == "" or len(conf) != 4 or dim <= 0:
  print "Error getopt" 
  sys.exit(2)

 algo = "sa"
 N,M = 200,1

 Head = {'algo':algo,'conf':"T0,alpha,P,L = {0},{1},{2},{3}".format(conf[0],conf[1],conf[2],conf[3]),'dim':dim,"dataset":dataset}
 
 Y,names = [],[]
 cl = cPickle.load(open(dataset+"/"+"classes.txt","r"))
  #nm = amostra_base.amostra(dataset,NS)
 for k in cl.keys():
  Y.append(cl[k])
  names.append(k)
  
 def cost_func(args):  
  tt = time() 
  sigma = args[-1]
  raios = args[0:-1]
  N = len(names)
  Ncpu = getattr(sys.modules[__name__],"mt")
  Nc =  nc
#  limits_hi= np.linspace(2*N/Ncpu,N,Ncpu/2).astype(int)
#  limits_lo = np.hstack((0,limits_hi[0:limits_hi.shape[0]-1]))
#  idx =[np.arange(lo,hi) for lo,hi in zip(limits_lo,limits_hi)]
#  l = [np.array(names)[i].tolist() for i in idx]
#  print "Calculando hf"
#  p = Pool(processes = Ncpu/2) 
#  ff = partial(getattr(sys.modules[__name__],"fy"),nc = Nc)
#  res = p.map(ff,l)
#  p.close()
  Fl = [np.array([smooth(desc.dii(dataset+"/"+k,raio = r,nc = Nc,method = "octave"),sigma) for r in raios]) for k in names]
  
  #print "Calculando Silhouette"
  #cost = float(np.median(1. - silhouette(Fl,np.array(Y)-1,Nthreads = Ncpu)))
  md = pdist_mt(Fl,Ncpu) 
  l = np.zeros((Nclasses,Nretr),dtype = int)

  for i,nome in zip(np.arange(N),names):
  # Para cada linha de md estabelece rank de recuperacao
  # O primeiro elemento de cada linha corresponde a forma modelo
  # Obtem a classe dos objetos recuperados pelo ordem crescente de distancia
   idx = np.argsort(md[i])
  # pega classes a qual pertencem o primeiro padrao e as imagens recuperadas
   classe_padrao = cl[nome]
   name_retr = np.array(names)[idx] 
   aux = np.array([cl[j] for j in name_retr])
   classe_retrs = aux[0:Nretr]
   n = np.nonzero(classe_retrs == classe_padrao)
   for i in n[0]:
    l[classe_padrao-1,i] = l[classe_padrao-1,i] + 1 

  v = np.array([l[:,i].sum() for i in np.arange(Nretr)])
  cost = ((v - 99.)**2).sum()/v.shape[0]
  print args
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
 
