% 分析控制效果，数据是自动驾驶采集的
clear all;
close all;
% 指定CSV文件的路径
% these three group data is collecting by manually driving
a_csvFilePath = 'control_data_low_speed.csv';
b_csvFilePath = 'control_data_medium_speed.csv';

% 或者使用readmatrix函数（需要MATLAB R2019b或更新版本）

% [time,hour,min,seconds,originLLA_x, origin_LLA_y, origin_LLA_z,corn_x,corn_y,veh_x,...
%  veh_y, control_angle,lateral_error, heading_error,velocity,realtime_angle] = readvars(csvFilePath);
% 将数据转换为列向量
[time,hour,min,seconds,a_originLLA_x, a_origin_LLA_y, a_origin_LLA_z,a_corn_x,a_corn_y,...
    a_veh_x,a_veh_y, a_control_angle,a_lateral_error, a_heading_error,a_velocity,a_realtime_angle] = readvars(a_csvFilePath);
[time,hour,min,seconds,b_originLLA_x, b_origin_LLA_y, b_origin_LLA_z,b_corn_x,b_corn_y,...
    b_veh_x,b_veh_y, b_control_angle,b_lateral_error, b_heading_error,b_velocity,b_realtime_angle] = readvars(b_csvFilePath);



figure(1);
subplot(2,1,1)
title("corn position VS car moving path under low speed");
scatter(a_veh_x,a_veh_y,'black',  'filled',"LineWidth",2);
hold on;
scatter(a_corn_x,a_corn_y,'magenta' ,'filled');
legend("vehicle moving path", "corn position");
hold off;
axis equal;
% 
% subplot(2,1,2)
% title("corn position VS car moving path under medium speed");
% scatter(a_veh_x,a_veh_y,'black',  'filled',"LineWidth",2);
% hold on;
% scatter(a_corn_x,a_corn_y,'magenta' ,'filled');
% legend("vehicle moving path", "corn position");
% hold off;
% axis equal;
% 
% figure(2);
% title("reference target angle VS real angle over low speed")
% mean_angle = mean(a_realtime_angle);
% plot(mean_angle+a_control_angle);
% hold on;
% plot( a_realtime_angle)
% % scatter(b_control_angle, 'magenta' ,'filled');
% legend("reference angle", "realtime angle");
% hold off;

figure(3);
title("reference target angle VS real angle over mediumm speed")
mean_angle = mean(b_realtime_angle);
plot(mean_angle+b_control_angle);
hold on;
plot( b_realtime_angle)

legend("reference angle", "realtime angle");
hold off;

figure(4);
title("velocity");
plot(b_velocity);

figure(5);
subplot(2,1,1);
plot(b_lateral_error);
subplot(2,1,2);
plot(b_heading_error);
