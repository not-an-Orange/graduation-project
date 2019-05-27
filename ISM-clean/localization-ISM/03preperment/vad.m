function [voiceseg,SF] = vad(x,fs,wlen,inc)
x=x/max(abs(x));                        % 幅度归一化
N=length(x);                            % 取信号长度
time=(0:N-1)/fs;                        % 计算时间
%figure
% pos = get(gcf,'Position');              % 作图
% set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)]);
% plot(time,x,'k');         
% title('VAD');
%ylabel('幅值'); axis([0 max(time) -1 1]); grid;
%xlabel('时间/s');
%wlen=512; inc=256;                       % 分帧参数
IS=0.1; overlap=wlen-inc;               % 设置IS
NIS=fix((IS*fs-wlen)/inc +1);           % 计算NIS
fn=fix((N-wlen)/inc)+1;                 % 求帧数
frameTime=frame2time(fn, wlen, inc, fs);% 计算每帧对应的时间
[voiceseg,vsl,SF,NF]=vad_ezm1(x,wlen,inc,NIS);  % 端点检测

%for k=1 : vsl                           % 画出起止点位置
%    nx1=voiceseg(k).begin; 
%    nx2=voiceseg(k).end;
%     nxl=voiceseg(k).duration;
%    %fprintf('%4d   %4d   %4d   %4d\n',k,nx1,nx2,nxl);
%     line([frameTime(nx1) frameTime(nx1)],[-1.5 1.5],'color','red','LineStyle','-');
%     line([frameTime(nx2) frameTime(nx2)],[-1.5 1.5],'color','green','LineStyle','--');
end
