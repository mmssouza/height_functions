
function [HFs,HF2s] = batch_hf(fnames,n_contour)
 m = length(fnames);
%---- sample every image and get scale values ----
 HFs = cell(1, m);
 HF2s = cell(1, m);
 for k = 1:m
    %-- Contour extraction
    im = double(imread(fnames{k}));
    im = im(:,:,1);            %im = 255 - im;             % additional process: for 255 background and 0 foreground (check the boundary, or may cause fatal error!)
    %im(im < 200) = 0;           % image preprocess 2: omit noise pixel values
    %im(im > 0) = 255;
    %[len, wid] = size(im);
    %im2 = zeros(len+2, wid+2);
    %im2(2:len+1,2:wid+1) = im;  % image preprocess 3: add empty lines around the object, avoiding contour error (which will make all later work useless!)
    im2 = im;
    im3 = im2'; % mirror image
    Cs = extract_longest_cont(im2, n_contour);
    Cs2 = extract_longest_cont(im3, n_contour);
    
    %-- HF for all landmark points --
    hf = compu_contour_HF(Cs);
    hf2 = compu_contour_HF(Cs2);
    HFs{k} = hf;
    HF2s{k} = hf2;
 end
