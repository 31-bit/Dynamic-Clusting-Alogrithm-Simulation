% 创建地图
close all;

length(corn_coordinates_all)
figure;
scatter(corn_ENU_x,corn_ENU_y,MarkerFaceColor =[0.8500 0.3250 0.0980])
hold on;
plot(corn_ENU_x,corn_ENU_y, 'black')
scatter(corn_coordinates_all(1:end,1),corn_coordinates_all(1:end,2),30,"green","filled","d")
legend("采集数据坐标", "采集数据时间线","玉米杆预测点");
%scatter(path_reference(1:end,1), path_reference(1:end,2),30,"magenta")
hold off;

% 创建地图
angle_point = [];

for i=1:length(corn_index_all)
    if which_sensor_all(i) == 1
        angle_point = [angle_point, sensor1af(corn_index_all(i))];
    else
        angle_point = [angle_point, sensor19f(corn_index_all(i))];
    end
end

figure;
plot(sensor19f);
hold on;
scatter(index,sensor19f,10, "filled");
scatter(index,sensor1af, 10, "filled");
scatter(corn_index_all, angle_point);
plot(sensor1af);
