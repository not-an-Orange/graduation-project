function   [positioning_mat] = eigenvector_y(G, tau_max, num_of_positioning_frame, num_of_activit_voice_frame)
%生成特征向量
%输入
%G，互相关矩阵
%tau_max,提取长度
%num_of_positioning_frame,定位用帧数
%num_of_activit_voice_frame,总活动语音帧数

%输出


k = 1;
A = zeros(num_of_activit_voice_frame-1,2*tau_max+1);
positioning_mat = zeros(num_of_positioning_frame,2*tau_max+1);

for i = 1:1:(num_of_activit_voice_frame-1)
        for j = -tau_max:1:tau_max
        A(i,k) = G(i,j+513);
        k = k+1;
        if k == 2*tau_max+1+1
            k = 1;
        end
        end
end
k = num_of_activit_voice_frame - num_of_positioning_frame;
%for i =  (num_of_activit_voice_frame - num_of_positioning_frame + 1):1: (num_of_activit_voice_frame - 1)
for i = 1: 1:  num_of_positioning_frame
    positioning_mat(i,:) = A(k,:);
    k = k + 1;
    if k == num_of_activit_voice_frame;
        k = num_of_activit_voice_frame - num_of_positioning_frame;
    end
end