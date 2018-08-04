clc;
clear;
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

mmx = min(xx):max(xx);

% 训练x-y
p = xx; % 每列为一组训练数据
t = yy;

%建立BP神经网络
netxy = newff(p,t,5);

%最大训练次数
netxy.trainParam.epochs = 5000;

%网络的学习速率
netxy.trainParam.lr = 0.1;

%训练网络所要达到的目标误差
netxy.trainParam.goal = 1e-3;

%网络误差如果连续6次迭代都没变化，则matlab会默认终止训练。为了让程序继续运行，用以下命令取消这条设置
netxy.divideFcn = '';

%开始训练网络
netxy = train(netxy, p, t);

neu_yy = sim(netxy, mmx);

% plot(mmx, neu_yy);
% title('x-y');
% xlabel('x'),ylabel('y');





% 训练x-z
pp = xx;  % 每列为一组训练数据
tt = zz;

netxz = newff(pp,tt,5);

netxz.trainParam.epochs = 5000;

netxz.trainParam.lr = 0.1;

netxz.trainParam.goal = 1e-3;

netxz.divideFcn = '';

%开始训练网络
netxz = train(netxz, pp, tt);

neu_zz = sim(netxz, mmx);

% plot(xx,zz);

% plot3(xx, yy, zz);
% xlabel('x'),ylabel('y'),zlabel('z');

min_x = min(xx);
max_x = max(xx);

xx = min_x:max_x;


subplot(2,2,1);
plot3(xx, neu_yy, neu_zz);
title('血管中轴线');
xlabel('x'),ylabel('y'),zlabel('z');

subplot(2,2,2);
plot(xx, neu_yy);
title('x-y');
xlabel('x'),ylabel('y');

subplot(2,2,3);
plot(neu_yy, neu_zz);
title('y-z');
xlabel('y'),ylabel('z');

subplot(2,2,4);
plot(xx, neu_zz);
title('x-z');
xlabel('x'),ylabel('z');

% plot(xx, yyy);
% plot(yyy, zzz);
% plot(xx, zzz);


