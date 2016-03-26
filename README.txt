This fold contains all necessary code files for shape matching with height functions (HF).


The matching process includes the following four steps:

batch_HF.m           : calculating the original height functions features for all shapes in some data set, and storing them in one .mat file
hisHF.m              : smoothing and local normalization
HF_shape_retrieval.m : DP matching based on height functions
HF_SC.m              : improving shape similarity values by shape complexity

There are some parameters in the codes, and they should be changed by modifying the codes in specific places.

All necessary functions to run the above code files are put in the fold 'commom_HF'. Some of these functions are implemented by directly using or slightly changing the source codes of Inner-Distance Shape Context (IDSC) provided online by Ling and Jacobs.


For more details, please refer to
Wang, J., Bai, X., You, X., Liu, W., Latecki, L.J., Shape Matching and Classification Using Height Functions, Pattern Recognition Letters (PRL), 2012, 33(2):134-143.
(doi: 10.1016/j.patrec.2011.09.042)


Xiang Bai
Ph.D, Department of Electronics and Information Engineering, Huazhong University of Science and Technology
1037 Luoyu Road, Wuhan, Hubei Province 430074, P. R. China
http://mc.eistar.net/~xbai/
November 8th, 2011
