Q_r = zeros(47,47,17);
for i = 1:1:17
    Q_r(:,:,i) = diag(sigma(i,:));
end
save Q_r.mat Q_r;