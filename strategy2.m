corn_coordinates_all = [];
corn_index_all = [];
which_sensor_all = [];

minleft = mean(sensor1af(1:5));
minright = mean(sensor19f(1:5));

which_sensor = 0;

angleleft =  abs(sensor1af - minleft);
angleright = abs(sensor19f - minright);
max_value = 0;
max_index = 0;
max_pos = [0.0, 0.0];

for i = 3: length(angleleft)-2
     if (angleleft(i)>2)||(angleright(i)>2)
         if angleleft(i) > angleright(i)
             angle_temp = angleleft;
             which_sensor = 1;
         else
             angle_temp = angleright;
             which_sensor = 2;
         end
     else
         continue
     end

     if (angle_temp(i)> angle_temp(i-1)) && (angle_temp(i)> angle_temp(i+1))...
            (angle_temp(i-1)> angle_temp(i-2))&&(angle_temp(i+1)> angle_temp(i+2))

         if isempty(corn_coordinates_all)  % 第一个极值点直接append
             max_pos = [corn_ENU_x(i), corn_ENU_y(i)];
             corn_coordinates_all = [corn_coordinates_all; max_pos];
             which_sensor_all = [which_sensor_all, which_sensor];
             corn_index_all =[corn_index_all,i];
         else % 后面判断他和上一个点的距离是否够大
            if sqrt((corn_ENU_x(i)- corn_coordinates_all(end,1))^2+ ...
                (corn_ENU_y(i)-corn_coordinates_all(end,2))^2) > 0.2 % 大于15公分
                max_pos = [corn_ENU_x(i), corn_ENU_y(i)];
                corn_coordinates_all = [corn_coordinates_all; max_pos];
                which_sensor_all = [which_sensor_all, which_sensor];
                corn_index_all =[corn_index_all,i];
            end
         end
     end
end
length(corn_coordinates_all)