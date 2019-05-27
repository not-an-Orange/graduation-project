clear all
close all
clc

addpath(genpath('G:\graduation project\function\ISM,有混淆无噪声，应该是最终版\train_ISM'));
[SrcSignalVec,fs] = audioread('pure.wav');


%初始化参数/预处理
win_len = 512;                                                             %帧长
hop = 256;                                                                 %帧移

%初始化参数/特征提取
r = 2;                                                                     %两麦克风中心与声源间距
[x,y,z] = deal(zeros(1,17));
[mu, sigma] = deal(zeros(17,47));
alpha = 1.67;                                                              %某因子
mic_distant = 0.3;                                                         %两麦克间距离
vio_speed = 343;                                                           %声速
tau_max = round(alpha*mic_distant*fs/vio_speed);
train_frame = 100;

%训练阶段开始
for i = 1:1:17
    x(i) = 4+r*cos(10*i*pi/180);                                           %生成十七个点的位置坐标
    y(i) = 2.5+ r*sin(10*i*pi/180);
    z(i) = 1.2;
figure
    SetupStruc_1 = my_ISM_setup_1(x(i),y(i),z(i));                         %加混响
    ISM_RIR_bank(SetupStruc_1,'ISM_RIRs.mat');
    mic1_recorded_volume = ISM_AudioData('ISM_RIRs.mat',SrcSignalVec); 
    SetupStruc_2 = my_ISM_setup_2(x(i),y(i),z(i));
    ISM_RIR_bank(SetupStruc_2,'ISM_RIRs.mat');
    mic2_recorded_volume = ISM_AudioData('ISM_RIRs.mat',SrcSignalVec);


%分帧加窗/预处理
enframe_done_1 = enframe(mic1_recorded_volume,hanning(win_len),hop);       %此处使用汉宁窗
enframe_done_2 = enframe(mic2_recorded_volume,hanning(win_len),hop);

%端点检测/预处理
%mic1_pre_emphasis=filter([1 -0.9],[1 1],mic1_recorded_volume);
[voice_seg1,SF1] = vad(mic1_recorded_volume,fs,win_len,hop);               %问题！！！预加重后端点检测效果反而变差
%mic2_pre_emphasis=filter([1 -0.8],[1 1],mic2_recorded_volume);
[voice_seg2,SF2] = vad(mic2_recorded_volume,fs,win_len,hop);


%求广义互相关函数/计算阶段
[G,num_of_activit_voice_frame,lags] = GCC_transfer(SF1,SF2,enframe_done_1,enframe_done_2,fs);

%特征提取/计算阶段
[mu_1, sigma_1] = eigenvector(G, tau_max, train_frame,num_of_activit_voice_frame);
mu(i,:) = mu_1;
sigma(i,:) = sigma_1;
end
save mu.mat mu;
save sigma.mat sigma;