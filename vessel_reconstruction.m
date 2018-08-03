parent_folder = './血管切片/';
img_num = 100;
img_size = 512;
img_extension = '.bmp';
img_cell = cell(1, img_num);
img_feature = zeros(3, 100);
for i = 1:img_num
    A = imread([parent_folder, num2str(i - 1), img_extension]);
    A = ~A; %很奇怪，不取反会产生外边框，严重影响内切圆判断
%     AA = bwperim(A,8);
%     imshow(AA);
%     max_inscribed_circle(im2uint8(AA), 1);
    img_cell{1, i} = bwperim(A, 8) .* 255;  %转灰度图，保存轮廓
    [R, cx, cy] = max_inscribed_circle(img_cell{1, i}, 0);
    img_feature(1, i) = R;
    img_feature(2, i) = cx;
    img_feature(3, i) = cy;
end

vessel_radius = max(img_feature(1, :)) / 2; %血管半径，取最大还是取平均？

zz = 1:1:100;
yy = img_feature(2, :);
xx = img_feature(3, :);

% plot(xx,zz);

% plot3(xx, yy, zz);
% xlabel('x'),ylabel('y'),zlabel('z');

min_x = min(xx);
max_x = max(xx);

xx = min_x:max_x;

% 7次，还需继续确定参数，这里时间有限，只提供了一个近似的
yyy = 4.154e-14*xx.^7 + -8.748e-11*xx.^6 + 7.613e-08*xx.^5 + -3.546e-05*xx.^4 + 0.009531*xx.^3 + -1.479*xx.^2 + 123.4*xx + -3928;
zzz = 4.1e-14*xx.^7 + -8.052e-11*xx.^6 + 6.584e-08*xx.^5 + -2.897e-05*xx.^4 + 0.007384*xx.^3 + -1.086*xx.^2 + 85.38*xx + -2714;

% 9次
% yyy = 4.164e-18*xx.^9 + -1.097e-14*xx.^8 + 1.25e-11*xx.^7 + -8.09e-09*xx.^6 + 3.267e-06*xx.^5 + -0.0008526*xx.^4 + 0.1435*xx.^3 + -15.02*xx.^2 + 886.1*xx + -2.216e+04;
% zzz = 4.605e-18*xx.^9 + -1.154e-14*xx.^8 + 1.256e-11*xx.^7 + -7.779e-09*xx.^6 + 3.015e-06*xx.^5 + -0.0007569*xx.^4 + 0.1228*xx.^3 + -12.4*xx.^2 + 706*xx + -1.721e+04;

subplot(2,2,1);
plot3(xx, yyy, zzz);
title('血管中轴线');
xlabel('x'),ylabel('y'),zlabel('z');

subplot(2,2,2);
plot(xx, yyy);
title('x-y');
xlabel('x'),ylabel('y');

subplot(2,2,3);
plot(yyy, zzz);
title('y-z');
xlabel('y'),ylabel('z');

subplot(2,2,4);
plot(xx, zzz);
title('x-z');
xlabel('x'),ylabel('z');

% plot(xx, yyy);
% plot(yyy, zzz);
% plot(xx, zzz);


