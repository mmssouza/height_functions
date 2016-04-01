
%function [HFs,HF2s] = batch_hf(fnames,n_contour)
function [HFs] = batch_hf(fnames,n_contour)
 m = length(fnames);
 %ifname = cell(1, m);
 %for i = 1 : m  % batch process
 % ifname{i} = fnames{i}
 %end 
%---- sample every image and get scale values ----
 HFs = cell(1, m);
 %HF2s = cell(1, m);
 %n_contour = 100;
 for k = 1:m
    %-- Contour extraction
    %im = double(imread(ifname{k}));
    im = double(imread(fnames{k}));
    im = im(:,:,1);            %im = 255 - im;             % additional process: for 255 background and 0 foreground (check the boundary, or may cause fatal error!)
    %im(im < 200) = 0;           % image preprocess 2: omit noise pixel values
    %im(im > 0) = 255;
    %[len, wid] = size(im);
    %im2 = zeros(len+2, wid+2);
    %im2(2:len+1,2:wid+1) = im;  % image preprocess 3: add empty lines around the object, avoiding contour error (which will make all later work useless!)
    im2 = im;
    %im3 = im2'; % mirror image
    Cs = extract_longest_cont(im2, n_contour);
    %Cs2 = extract_longest_cont(im3, n_contour);
    %Cs2 = extract_longest_cont_original(im2);
    
% %     % have to check, contour error?
%        figure(1);
%        imshow(255*ones(size(im2))); hold on;
%        plot(Cs2(:,1), Cs2(:,2), 'k'); hold on; % boundary curve
%        plot(Cs(:,1), Cs(:,2), 'ok', 'MarkerFaceColor', 'k'); hold on; % all sample points
%        plot(Cs(100,1), Cs(100,2), 'sr', 'MarkerFaceColor', 'r'); hold on;
%        % object point
%        plot(Cs(99,1), Cs(99,2), 'ob', 'MarkerFaceColor', 'b');
%        plot(Cs(1,1), Cs(1,2), 'ob', 'MarkerFaceColor', 'b'); % neighbor points
%       %saveas(figure(1), strcat('D:\MATLABR2008b\work\tmp\ETH\contour for', f_structure(k+2).name, '.jpg'));
% %      close(figure(1));
% %     %
    
    %-- HF for all landmark points --
    hf = compu_contour_HF(Cs);
    %tt = compu_contour_HF_sa(Cs);
    %hf2 = compu_contour_HF(Cs2);
    HFs{k} = hf;
    %HF2s{k} = hf2;
    %fprintf('Process shape %i end \n', k);
 end
