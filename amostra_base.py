#!/usr/bin/python

import sys
import numpy as np
import cPickle

def amostra(path,N = 3):
 cl = cPickle.load(open(path+"/"+"classes.txt"))
 classes = np.array(cl.values())
 samples_list = []
 for i in np.arange(1,classes.max()+1):
  idx1 = np.where(classes == i)
  idx2 = np.random.permutation(idx1[0].shape[0])
  idx3 = idx1[0][idx2[0:N]]
  samples_list = samples_list + [cl.keys()[j] for j in idx3]
 return samples_list
 
