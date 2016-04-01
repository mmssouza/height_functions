% [sshr] = compu_contour_SSHR( cont )
% 
% Compute the global segment height representation of the given contour points.
%
% Output	
%	sshr		: global segment height representation, N columns, the i-th column is a N-3 
%				vector indicating the shr feature at the i-th point
%
% Input:	
%	cont	: Nx2 matrix, input N contour points
%
% how to get the height of every point related to the chord:
% triangle area = 0.5*det(triple) = 0.5*chord * height
%
%	Junwei Wang, MC lab, EI, hust.edu.cn  2010.08.27
%
function [hf] = compu_contour_HF( cont )
											
%------ Parameters ----------------------------------------------
n_pt= size(cont,1);
X	= cont(:,1);
Y	= cont(:,2);  % X,Y are both column vectors
hf = zeros(n_pt-3, n_pt);

%-- Geodesic distances between all landmark points ---------
Xs			= repmat(X,1,n_pt);  % Xs = [X X ... X];
dXs			= Xs-Xs';
Ys			= repmat(Y,1,n_pt);  % Xs,Ys are both square matrix 
dYs			= Ys-Ys';
dis_mat		= sqrt(dXs.^2+dYs.^2);    % this data representation and algorithm to get all distances is great! use matrix operations naturally.
diameter    = max(dis_mat(:));  % max or mean both try

%-- SAR for every landmark point ---------
X3 = repmat(X,3,1);
Y3 = repmat(Y,3,1);

for p_index = 1+n_pt : n_pt+n_pt
    scale_index = round(n_pt/2-1);
    left = p_index-scale_index;
    right = p_index+scale_index;
    chord = pdist([X3(left) Y3(left); X3(right) Y3(right)]); % chord length
    height_vector = zeros(2*scale_index-1, 1);
    for i = left+1 : right-1
        height_vector(i-left) = det([X3(left) Y3(left) 1; X3(i) Y3(i) 1; X3(right) Y3(right) 1]); % signed area
    end
    height_vector = height_vector / chord; % signed height
	if mod(n_pt,2) == 1
     hf(:, p_index-n_pt) = height_vector(1:size(height_vector,1) - 1);
	else
     hf(:, p_index-n_pt) = height_vector;
	endif
end

%-- Normalize tar with the shape diameter --------------------
hf = hf / diameter;

return;
