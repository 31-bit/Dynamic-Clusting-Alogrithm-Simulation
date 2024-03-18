% row = 2;
% col = 1;
% M = csvread('candata2.csv', row, col)
close all;
time = VarName1(2:-1);
origin_lat = VarName5(100);
origin_lon = VarName6(100);
origin_alt = VarName7(100);

corn_ENU_x = VarName9(2:end);
corn_ENU_y = VarName10(2:end);
corn_ENU_z = VarName11(2:end);

sensor19f = f(2:end);
sensor1af = af(2:end);
index = 1:length(sensor19f);
% 创建地图
figure;
scatter(corn_ENU_x,corn_ENU_y,MarkerFaceColor =[0.8500 0.3250 0.0980]);
hold on;
plot(corn_ENU_x,corn_ENU_y, 'black')
hold off;

figure;
plot(sensor19f);
hold on;
scatter(index,sensor19f,10, "filled");
scatter(index,sensor1af, 10, "filled");
plot(sensor1af);