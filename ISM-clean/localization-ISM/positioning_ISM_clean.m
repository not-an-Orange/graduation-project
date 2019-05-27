function [re] = positioning_ISM_clean(num_test1)
% clear all
% close all
% clc

import_data;                                                               %��������
[SrcSignalVec,fs] = audioread('pure.wav');                                 %��������

%��ʼ������/��ȡ��������
alpha = 1.67;                                                              %ĳ����
mic_distant = 0.3;                                                         %����˼����
vio_speed = 343;                                                           %����
tau_max = round(alpha*mic_distant*fs/vio_speed);
num_of_positioning_frame = 60;                                             %������֡��
num_test = num_test1;                                                              %����֡��

for i = 1:1:17
location = i;                                                              %�ڼ���λ��

SetupStruc_1 = my_ISM_setup_1(x(location), y(location), z(location));      %�ӻ���
ISM_RIR_bank(SetupStruc_1,'ISM_RIRs.mat');
mic1_recorded_volume = ISM_AudioData('ISM_RIRs.mat',SrcSignalVec);
SetupStruc_2 = my_ISM_setup_2(x(i),y(i),z(i));
ISM_RIR_bank(SetupStruc_2,'ISM_RIRs.mat');
mic2_recorded_volume = ISM_AudioData('ISM_RIRs.mat',SrcSignalVec);

%��ʼ������/Ԥ����
win_len = 512;                                                             %֡��
hop = 256;                                                                 %֡��

%��֡�Ӵ�/Ԥ����
enframe_done_1 = enframe(mic1_recorded_volume,hanning(win_len),hop);       
enframe_done_2 = enframe(mic2_recorded_volume,hanning(win_len),hop);

%�˵���/Ԥ����
[voice_seg1,SF1] = vad(mic1_recorded_volume,fs,win_len,hop);               
[voice_seg2,SF2] = vad(mic2_recorded_volume,fs,win_len,hop);

%���ɻ���غ���
[G,activit_voice_frame_num,lags] = GCC_transfer(SF1,SF2,enframe_done_1,enframe_done_2,fs);


%������������
positioning_mat = eigenvector_y(G, tau_max, num_of_positioning_frame, activit_voice_frame_num);

%�ж�λ��
[r_s, p_r] = naive_byaes(positioning_mat, mu1,Q_r,tau_max,num_test, num_of_positioning_frame);
rs_mat(:,i) = r_s';
end
[result] = caculate( rs_mat, num_of_positioning_frame, num_test);
re = result;