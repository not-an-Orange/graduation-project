close all
clear all
clc
tic
result = zeros(1,6);
for i = 1:1:6
    re = positioning_ISM_clean(i);
    result(i) = re;    
end
toc