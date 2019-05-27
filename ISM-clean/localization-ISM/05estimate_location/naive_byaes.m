function [r_s, p_r] = naive_byaes(y,mu_r,Q_r,tau_max,num_test, num_of_positioning_frame)

%y,特征向量或特征向量组
%mu_r,均值
%Q_r，协方差矩阵
%tau_max,就是那个长度了
%num_test，测试帧数
%num_of_positioning_frame,测试总帧数

N = num_test;
j=1;
for i = 1: num_test: num_of_positioning_frame
    for j = 1:1:17
        coeiffiecent_1 = (2*pi)^(2*tau_max+1);
        coeiffiecent_2 = det(Q_r(:,:, j))*1e+52;
        coeiffiecent = 1./(sqrt(coeiffiecent_1*coeiffiecent_2))^N;
        sum = 0;
        for k = 1: 1: num_test
        intermediate_variables = y(i+ k -1,:) - mu_r(j, :);
        index = -(intermediate_variables*inv(Q_r(:, :, j))*intermediate_variables')./2;
        sum = sum + index;
        p_r(j) = coeiffiecent.*exp(sum);
        end
     end
[max_num, rs] = max(p_r);
r_s(i) = rs;
end
