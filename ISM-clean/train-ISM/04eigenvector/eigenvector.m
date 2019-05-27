function   [mu, sigma] = eigenvector(G, tau_max, num_of_train_frame,num_of_activit_voice_frame)
%生成特征向量
%输入
%G，互相关矩阵
%tau_max,提取长度
%num_of_train_frame,训练用帧数
%num_of_activit_voice_frame,总活动语音帧数

%输出
%mu，均值
%sigma，方差

k = 1;
A = zeros(num_of_activit_voice_frame-1,2*tau_max+1);
mu = [];
sigma = [];
for i = 1:1:(num_of_activit_voice_frame-1)
        for j = -tau_max:1:tau_max
        A(i,k) = G(i,j+513);
        k = k+1;
        if k == 2*tau_max+1+1
            k = 1;
        end
        end
end

for i = 1:1:num_of_train_frame
    train_mat(i,:) = A(i,:);
end

mu = mean(train_mat);
sigma = var(train_mat);