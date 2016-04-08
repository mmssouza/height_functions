import sys
import scipy
import numpy as np
from multiprocessing import Queue,Process
from fastdtw import fastdtw

beta = 0.001
alpha = 1.
radius = 1

def set_param(b,a,r):
 setattr(sys.modules[__name__],"beta",b)
 setattr(sys.modules[__name__],"alpha",a)
 setattr(sys.modules[__name__],"radius",r)
 
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

def pdist(X,idx,q):
 N = len(X)
 p = scipy.zeros((N,N))
 for i in idx:
  for j in scipy.arange(i,N):
   if i != j:
    p[i,j] = dist(X[i],X[j])
  q.put(scipy.hstack((i,p[i]))) 	  
 q.put(scipy.hstack((-1,scipy.zeros(N)))) 

def worker(in_q,out_q):
  args = in_q.get()
  pdist(args[0],args[1],out_q)

def pdist_mt(X,Nthreads = 8):

 Nobj = len(X)

 limits_hi= scipy.linspace(Nobj/Nthreads,Nobj,Nthreads).astype(int)
 limits_lo = scipy.hstack((0,limits_hi[0:limits_hi.shape[0]-1]))
 idx =[scipy.arange(lo,hi) for lo,hi in zip(limits_lo,limits_hi)]

# Filas para comunicar com threads
 in_q,out_q = Queue(),Queue()
# Ativa as threads
 threads = []
 for i in range(Nthreads):
  t =  Process(target=worker,args=(in_q,out_q))
  threads.append(t)

 for p in threads:
  p.start()
  
 for i in idx:
  in_q.put([X,i])
 
 aux = 0;
 md = []
 while aux != Nthreads:
  a = out_q.get()
  if a[0] == -1:
   aux = aux + 1   
   continue
  md.append(a)
 md = scipy.array(md)
 idx = scipy.argsort(md[:,0])
 md = md[idx]
 md = scipy.delete(md,0,axis = 1)
 md = md + md.T
 return md

def silhouette(X, cIDX, Nthreads = 8):
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
    D = pdist_mt(X, Nthreads = Nthreads)
 
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
