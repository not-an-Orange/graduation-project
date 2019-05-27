function   [mu, sigma] = eigenvector(G, tau_max, num_of_train_frame,num_of_activit_voice_frame)
%������������
%����
%G������ؾ���
%tau_max,��ȡ����
%num_of_train_frame,ѵ����֡��
%num_of_activit_voice_frame,�ܻ����֡��

%���
%mu����ֵ
%sigma������

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