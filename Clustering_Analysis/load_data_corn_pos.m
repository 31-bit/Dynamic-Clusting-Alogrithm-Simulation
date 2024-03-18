% 检验玉米点拟合的坐标算法是否准确
% 采集三组数据，2组低速1km/h。确保速度本身一样，玉米杆拟合误差相差不多
% 比较高速下玉米杆的坐标是否失真严重与低速相比较
% 指定CSV文件的路径
% these three group data is collecting by manually driving
a_csvFilePath = 'Corn_pos_low_speed1km_a.csv';
b_csvFilePath = 'Corn_pos_low_speed1km_b.csv';
c_csvFilePath = 'Corn_pos_medium_speed3km.csv';
% 或者使用readmatrix函数（需要MATLAB R2019b或更新版本）

% [time,hour,min,seconds,originLLA_x, origin_LLA_y, origin_LLA_z,corn_x,corn_y,veh_x,...
%  veh_y, control_angle,lateral_error, heading_error,velocity,realtime_angle] = readvars(csvFilePath);
% 将数据转换为列向量

% 低速第一组数据 这两组数据是一个经纬高原点，不用转换
low_speed_a_corn_x =  readvars(a_csvFilePath,'Range','H1:H3375');
low_speed_a_corn_y =  readvars(a_csvFilePath,'Range','I1:I3375');
low_speed_a_car_x_dirty =  readvars(a_csvFilePath,'Range','J1:J3375');
low_speed_a_car_y_dirty =  readvars(a_csvFilePath,'Range','K1:K3375');
low_speed_a_car_x = [];
low_speed_a_car_y = [];

control_angle = readvars(c_csvFilePath,'Range','L375:L1483');
realtime_angle = readvars(c_csvFilePath,'Range','P375:P1483');
c_laternal_error = readvars(c_csvFilePath,'Range','M375:M1483');
c_heading_error = readvars(c_csvFilePath,'Range','N375:N1483');

for i = 1:length(low_speed_a_car_x_dirty) 
    if low_speed_a_car_x_dirty(i)>0 && low_speed_a_car_x_dirty(i)<1000
        low_speed_a_car_x = [low_speed_a_car_x, low_speed_a_car_x_dirty(i)];
        low_speed_a_car_y = [low_speed_a_car_y, low_speed_a_car_y_dirty(i)];
    end 
end
% 低速第二组数据
low_speed_b_corn_x =  readvars(b_csvFilePath,'Range','H1:H1902');
low_speed_b_corn_y =  readvars(b_csvFilePath,'Range','I1:I1902');

% 高速第一组, 同一个原点
high_speed_c_corn_x =  readvars(c_csvFilePath,'Range','H1:H1501');
high_speed_c_corn_y =  readvars(c_csvFilePath,'Range','I1:I1501');

figure(1);
title("corn clustering eresult at different speed ");
scatter(low_speed_a_corn_x,low_speed_a_corn_y,'magenta','filled');
hold on;
scatter(low_speed_b_corn_x,low_speed_b_corn_y,'blue','filled');
scatter(high_speed_c_corn_x,high_speed_c_corn_y,'green','filled');
legend('low speed a','low speed b', 'high speed c')
axis equal;
hold off;

figure(2);
title("corn position VS car moving path");
scatter(low_speed_a_car_x,low_speed_a_car_y,'black',  'filled',"LineWidth",2);
hold on;
scatter(low_speed_a_corn_x,low_speed_a_corn_y,'magenta' ,'filled');
legend("vehicle moving path", "corn position");
hold off;
axis equal;

figure(3);
% the laternal error needs to be enlarged 5 times more to achieveiv to investigate the tracking peformance of control variable
title("control_angle VS realtime angle");
plot(control_angle(1:1000))
hold on;
plot(realtime_angle(1:1000)-252.80)
hold off;
legend('control_angle','realtime_angle')

figure(4);
% to justify the potential of sliding mode control
scatter(c_laternal_error,c_heading_error);
xlabel('laternal');
ylabel('heading')