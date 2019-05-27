load x.mat x;
load y.mat y;
load z.mat z;

load mu_un_100.mat mu;
mu1 = mu;
load sigma_un_100.mat sigma;

Q_r = zeros(47,47,17);
for i =1:1:17
Q_r(:,:,i) = diag(sigma(i,:));
end