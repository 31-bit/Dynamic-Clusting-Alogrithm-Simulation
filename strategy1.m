% strategy 1: arrouding to the sensor data, find the index of the max point.
corn_coordinates_all = [];
corn_index_all = [];
which_sensor_all = [];

minleft = mean(sensor1af(1:5));
minright = mean(sensor19f(1:5));
flag_touch = 0;
flag_up = 1;
which_sensor = 0;
which_sensor_last = which_sensor;
angleleft =  abs(sensor1af - minleft);
angleright = abs(sensor19f - minright);
max_value = 0;
max_index = 0;
max_pos = [0.0, 0.0];
index_begin = 0;

for i = 1: length(sensor1af)
    % 当其中一个角位移开始有数据的时候，坐标才是有意义的

    if (angleleft(i)>2)||(angleright(i)>2)
        max_index = i
        max_pos = [corn_ENU_x(i), corn_ENU_y(i)]
        flag_touch =1;
        index_begin = i;
        which_sensor_last = 1;
        max_value = angleleft(i);
    end
    if angleleft(i)<angleright(i)
        which_sensor_last = 2;
        max_value = angleright(i);
    end
    if flag_touch == 1
        break;
    end
end
angle_temp = angleleft;
for i = index_begin:length(sensor1af)
    if angleleft(i) > angleright(i)
        which_sensor = 1; % left work
        angle_temp = angleleft;
    else
        which_sensor = 2; % right work
        angle_temp = angleright;
    end
    %是同一个探测杆子打到玉米杆，也说明还是同一根玉米杆
    if which_sensor == which_sensor_last
        %如果角度大，记录当前位置
        if angle_temp(i) >= max_value
            max_value = angle_temp(i);
            max_index = i;
            max_pos = [corn_ENU_x(i), corn_ENU_y(i)];
            flag_up = 1;
        else%如果角度变小，且变化量大于某个值，则记录下降。并将上个点坐标推到玉米杆
            if (angle_temp(max_index) - angle_temp(i) > 1.5) 
                if length(corn_coordinates_all)<1 %第一个点
                    corn_coordinates_all = [corn_coordinates_all; max_pos];
                    corn_index_all = [corn_index_all, i];
                    which_sensor_all = [which_sensor_all, which_sensor];
                    max_value = 0;

                    flag_up = 0;
                else % 不是第一个点
                    if (sqrt((corn_ENU_x(i)- corn_coordinates_all(end,1))^2 ...
                            +(corn_ENU_y(i)-corn_coordinates_all(end,1))^2) > 0.2)...
                            && (flag_up == 1)
                        % 和上一个玉米杆距离大于15厘米
                        corn_coordinates_all = [corn_coordinates_all; max_pos];
                        corn_index_all = [corn_index_all, i];
                        which_sensor_all = [which_sensor_all, which_sensor];
                        max_value = 0;
                        max_index = i;
                        flag_up = 0;
                    end
                end
            end
        end
    else
        %判断是否与上一个玉米杆距离足够，如果够，将上一时刻坐标推入队列，并重新初始化temp
        if sqrt((corn_ENU_x(i)- corn_coordinates_all(end,1))^2+ ...
                (corn_ENU_y(i)-corn_coordinates_all(end,1))^2) > 0.15% 大于15公分
            
            max_value = angle_temp(i);
            max_index = i;
            corn_coordinates_all = [corn_coordinates_all; max_pos];
            corn_index_all = [corn_index_all, i];
            which_sensor_all = [which_sensor_all, which_sensor];
        end
    end
    which_sensor_last = which_sensor
end

length(corn_coordinates_all)