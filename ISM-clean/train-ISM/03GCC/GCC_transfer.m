function [G,num_of_activit_voice_frame,lags] = GCC_transfer(SF1,SF2,enframe_done_1,enframe_done_2,fs)

%SF1,SF2：vad帧号
%enframe_done_1,enframe_done_2:分帧后的语音信号
%fs：频率

%G:互相关函数的矩阵

Pxx = [];
Pxy = [];
Pyy = [];
activit_voice_frame=[];

%求互相关函数及特征向量
num_of_activit_voice_frame = 1;
for i=1:1:356
    if SF1(i) == 1 && SF2(i) == 1
        activit_voice_frame(num_of_activit_voice_frame) = i;
        num_of_activit_voice_frame = num_of_activit_voice_frame +1;
    end
end

for i = 1:1:(num_of_activit_voice_frame-1)
    [pxx(i,:),lags] = xcorr(enframe_done_1(i,:),enframe_done_1(i,:)); 
    [pyy(i,:),lags] = xcorr(enframe_done_2(i,:),enframe_done_2(i,:));  
    [pxy(i,:),lags] = xcorr(enframe_done_1(i,:),enframe_done_2(i,:));  
    Pxx(i,:) = fft(pxx(i,:));
    Pyy(i,:) = fft(pyy(i,:));
    Pxy(i,:) = fft(pxy(i,:));
end


G = GCC('unfiltered',Pxx,Pyy,Pxy,fs);                                            %scot滤波
%figure
%plot(G);
%[mu, sigma] = eigenvector(G, alpha, D, Fs);                                %V特征向量，D特征值
