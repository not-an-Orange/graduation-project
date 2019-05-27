clear all
close all
clc

addpath(genpath('G:\graduation project\function\ISM,�л�����������Ӧ�������հ�\train_ISM'));
[SrcSignalVec,fs] = audioread('pure.wav');


%��ʼ������/Ԥ����
win_len = 512;                                                             %֡��
hop = 256;                                                                 %֡��

%��ʼ������/������ȡ
r = 2;                                                                     %����˷���������Դ���
[x,y,z] = deal(zeros(1,17));
[mu, sigma] = deal(zeros(17,47));
alpha = 1.67;                                                              %ĳ����
mic_distant = 0.3;                                                         %����˼����
vio_speed = 343;                                                           %����
tau_max = round(alpha*mic_distant*fs/vio_speed);
train_frame = 100;

%ѵ���׶ο�ʼ
for i = 1:1:17
    x(i) = 4+r*cos(10*i*pi/180);                                           %����ʮ�߸����λ������
    y(i) = 2.5+ r*sin(10*i*pi/180);
    z(i) = 1.2;
figure
    SetupStruc_1 = my_ISM_setup_1(x(i),y(i),z(i));                         %�ӻ���
    ISM_RIR_bank(SetupStruc_1,'ISM_RIRs.mat');
    mic1_recorded_volume = ISM_AudioData('ISM_RIRs.mat',SrcSignalVec); 
    SetupStruc_2 = my_ISM_setup_2(x(i),y(i),z(i));
    ISM_RIR_bank(SetupStruc_2,'ISM_RIRs.mat');
    mic2_recorded_volume = ISM_AudioData('ISM_RIRs.mat',SrcSignalVec);


%��֡�Ӵ�/Ԥ����
enframe_done_1 = enframe(mic1_recorded_volume,hanning(win_len),hop);       %�˴�ʹ�ú�����
enframe_done_2 = enframe(mic2_recorded_volume,hanning(win_len),hop);

%�˵���/Ԥ����
%mic1_pre_emphasis=filter([1 -0.9],[1 1],mic1_recorded_volume);
[voice_seg1,SF1] = vad(mic1_recorded_volume,fs,win_len,hop);               %���⣡����Ԥ���غ�˵���Ч���������
%mic2_pre_emphasis=filter([1 -0.8],[1 1],mic2_recorded_volume);
[voice_seg2,SF2] = vad(mic2_recorded_volume,fs,win_len,hop);


%����廥��غ���/����׶�
[G,num_of_activit_voice_frame,lags] = GCC_transfer(SF1,SF2,enframe_done_1,enframe_done_2,fs);

%������ȡ/����׶�
[mu_1, sigma_1] = eigenvector(G, tau_max, train_frame,num_of_activit_voice_frame);
mu(i,:) = mu_1;
sigma(i,:) = sigma_1;
end
save mu.mat mu;
save sigma.mat sigma;