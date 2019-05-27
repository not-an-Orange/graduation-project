function [result] = caculate( rs_mat, num_of_positioning_frame, num_test)
% num_of_positioning_frame,²âÊÔ×ÜÖ¡Êý
%
n = size(rs_mat,1);
A = 1:1:17;
sta_mat = repmat(A, n,1);
B = rs_mat - sta_mat;
result = length(find(B == 0))/((num_of_positioning_frame/num_test)*17);