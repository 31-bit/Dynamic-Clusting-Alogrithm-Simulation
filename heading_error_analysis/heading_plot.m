% 考虑横偏较小的情况，航偏对控制影响较大�?��?�拟合线的误差本身会导致航偏不准�?
% 数据采集自自动驾驶的直线玉米杆�?�收尾相连拟合直线，看下两个数据相差
clear all;
close all;
% 指定CSV文件的路�?
% these three group data is collecting by manually driving
a_csvFilePath = '20240126.csv';


% [time,hour,min,seconds,originLLA_x, origin_LLA_y, origin_LLA_z,corn_x,corn_y,veh_x,...
%  veh_y, control_angle,lateral_error, heading_error,velocity,realtime_angle] = readvars(csvFilePath);
% 将数据转换为列向�?
[time,hour,minutes,seconds,a_originLLA_x, a_origin_LLA_y, a_origin_LLA_z,a_corn_x,a_corn_y,...
    a_veh_x,a_veh_y, a_control_angle,a_lateral_error, a_heading_error,a_velocity,a_heading] = readvars(a_csvFilePath);

% 玉米杆收尾两个点相连参�?�线的斜�?
slope_reference = atan2(a_corn_y(1241)-a_corn_y(554),a_corn_x(1241)-a_corn_x(554))
calculate_heading_error = a_heading - slope_reference;

% 将实时数据低通滤波看�?�?
% 滤波 先归�?�?
lowpass_heading_error = lowpass(a_heading_error(554:end),0.001);
figure(1);
title("realtime heading error VS calculate reference heading error");
plot(calculate_heading_error(554:end)-0.2);
hold on;
% plot(a_heading_error(554:end));
plot(lowpass_heading_error);
legend("calculate_heading_error", "a_heading_error");

hold off;

% 
figure(2)
subplot(4,1,1);
plot(a_lateral_error(554:end));
title("横偏 m");
subplot(4,1,2);
plot(a_heading_error(554:end)*180/pi);
title("航偏 degree");
subplot(4,1,3);
plot(lowpass_heading_error*180/pi);
title("低�?�滤波后航偏 degree")
subplot(4,1,4);
plot(a_velocity(554:end)*3.6);
title("速度 km/h")

figure(3);
% to justify the potential of sliding mode control
scatter(a_lateral_error(554:end),a_heading_error(554:end)*180/pi);
xlabel('laternal');
xlabel('laternal');
ylabel('heading');
