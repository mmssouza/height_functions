%-------- computing height functions feature for images --------%

addpath common_HF;
clear;

%---- file name parameters ----
% MPEG-7:    D:\MATLABR2008b\work\02_MPEG7_remove_holes
% Tari1000:  D:\MATLABR2008b\work\Tari_bmp
% ETH-80:    D:\MATLABR2008b\work\ETH-80
f_structure = dir('D:\MATLABR2008b\work\02_MPEG7_remove_holes');  % put all the files in a structure
m = length(f_structure);
%m=302;
ifname = cell(1, m-2);
for i = 3 : m  % batch process
    ifname{i-2} = strcat('D:\MATLABR2008b\work\02_MPEG7_remove_holes\', f_structure(i).name);
end

%---- sample every image and get scale values ----
HFs = cell(1, m-2);
HF2s = cell(1, m-2);
n_contour = 100;
%n_contour = 60;

T1 = fix(clock); % start time
for k = 1:m-2
    %-- Contour extraction
    im = double(imread(ifname{k}));
    im = im(:,:,1);             % image preprocess 1: for binary images, im(:,:,1) is simply the image itself. here is to avoid colour image data, which can't be processed by the 'extract_longest_cont' function
    %im = 255 - im;             % additional process: for 255 background and 0 foreground (check the boundary, or may cause fatal error!)
    im(im < 200) = 0;           % image preprocess 2: omit noise pixel values
    im(im > 0) = 255;
    [len, wid] = size(im);
    im2 = zeros(len+2, wid+2);
    im2(2:len+1,2:wid+1) = im;  % image preprocess 3: add empty lines around the object, avoiding contour error (which will make all later work useless!)
    im3 = im2'; % mirror image

    Cs = extract_longest_cont(im2, n_contour);
    Cs2 = extract_longest_cont(im3, n_contour);
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
    hf2 = compu_contour_HF(Cs2);
    HFs{k} = hf;
    HF2s{k} = hf2;
    
    fprintf('Process shape %i end \n', k);
end
T2 = fix(clock); % end time

%---- save MSTA for all shapes
save('HFs for MPEG7 with max-normal.mat', 'HFs');  % sshr
save('HF2s for MPEG7 with max-normal.mat', 'HF2s');  % sshr2

a = 1;
