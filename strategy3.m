corn_coordinates_all = [];
cluster_centre_all = [];
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

cluster_temp_x = [];
cluster_temp_y = [];
cluster_angle = [];


figure;
hold on;

for i = 1:length(corn_ENU_x)
    cluster_center_x = mean(cluster_temp_x);
    cluster_center_y = mean(cluster_temp_y);
    % 判读是哪个sensor
    if angleleft(i) > angleright(i)
        angle_temp = angleleft;
        if angleleft(i) < 1
            continue
        end
        which_sensor = 1;
        
    else
        angle_temp = angleright;
        if angleright(i) < 1
            continue
        end
        which_sensor = 2;
    end
    

    if isempty(cluster_temp_x)
        cluster_temp_x = [corn_ENU_x(i)];
        cluster_temp_y = [corn_ENU_y(i)];
        cluster_angle = [angle_temp(i)];
    else
        % if distance to the centre too big or oppsite triger touch something
        % clean cluster and begin next cluster converge
        if sqrt( (corn_ENU_x(i)-cluster_center_x)^2 ...
                + (corn_ENU_y(i)-cluster_center_y)^2 ) > 0.20 ...
                || which_sensor ~= which_sensor_last
                
            % select last cluster best data, then save to lib
            [max_angle_cluster, index_in_cluster] = max(cluster_angle);
            if (max_angle_cluster < 2) || ( length(cluster_temp_x) <3 )
                cluster_temp_x = [corn_ENU_x(i)];
                cluster_temp_y = [corn_ENU_y(i)];
                cluster_angle = [angle_temp(i)];
                continue
            end

            corn_coordinates_all = ...
            [corn_coordinates_all;cluster_temp_x(index_in_cluster), cluster_temp_y(index_in_cluster)];
            corn_index_all = [corn_index_all, i];
            which_sensor_all = [which_sensor_all, which_sensor_last];
            cluster_centre_all = [cluster_centre_all; cluster_center_x,cluster_center_y];

            % clean cluster and push first element
            scatter(cluster_temp_x , cluster_temp_y, 'filled', 'MarkerEdgeColor', rand(1, 3), 'MarkerFaceColor', rand(1, 3));
            cluster_temp_x = [corn_ENU_x(i)];
            cluster_temp_y = [corn_ENU_y(i)];
            cluster_angle = [angle_temp(i)];
        else % 距离不大，加到该类
            cluster_temp_x = [cluster_temp_x,corn_ENU_x(i)];
            cluster_temp_y = [cluster_temp_y,corn_ENU_y(i)];
            cluster_angle = [cluster_angle, angle_temp(i)];
        end
    end
    which_sensor_last= which_sensor;
end
scatter(corn_coordinates_all(1:end,1),corn_coordinates_all(1:end,2),30,"green","filled","d")
hold off;

length(corn_coordinates_all(1:end,1))