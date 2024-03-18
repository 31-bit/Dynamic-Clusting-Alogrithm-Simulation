close all;
figure; % 检验玉米杆选点是否是预期
hold on;
scatter(realtime_point(1:end, 1),realtime_point(1:end, 2),MarkerFaceColor =[0.8500 0.3250 0.0980]);
plot(realtime_point(1:end, 1),realtime_point(1:end, 2), 'black'); 
% plot realtime stick end position and connect the point
scatter(recent_point(1:end, 1),recent_point(1:end, 2),30,"green","filled","d");
% plot the chosen corn point and display with bigger sign
hold off;
axis equal;

figure; % 检验玉米杆AB线是否合理，摆动是否过大
hold on;
scatter(recent_point(1:end, 1),recent_point(1:end, 2),30,"green","filled","d");
for i = 1: length(referance_a)
    plot([referance_a(i,1); referance_b(i,1)] ,[referance_a(i,2); referance_b(i,2)]);
end
hold off
axis equal;

figure; % 验证拟合的ab线是否正确
hold on;
scatter(recent_point(1:end, 1),recent_point(1:end, 2),30,"green","filled","d");
SIZE_P = 6;
queue_x = [];
queue_y = [];
for i = 1: length(recent_point)
    if length(queue_x) < SIZE_P
        queue_x = [queue_x, recent_point(i,1) ];
        queue_y = [queue_y, recent_point(i,2) ];
    else
        queue_x = [queue_x(2:end), recent_point(i,1) ];
        queue_y = [queue_y(2:end), recent_point(i,2) ];
    end
    
    if length(queue_x) > 3 % calculate slope and plot AB
        sumX = 0;
        sumY = 0;
        sumXY = 0;
        sumX2 = 0;
        for k = 1:length(queue_x)
            x = queue_x(k);
            y = queue_y(k);
          
            sumX = sumX + x;
            sumY = sumY + y;
            sumXY = sumXY + x * y;
            sumX2 = sumX2 + x * x;
        end
        slope =  ( length(queue_x)* sumXY - sumX * sumY) / (length(queue_x) * sumX2 - sumX * sumX);
        AB_X = [recent_point(i,1), 5+recent_point(i,1)];
        AB_Y = [recent_point(i,2), 5*slope + recent_point(i,2)];
        plot(AB_X,AB_Y);
    end
end
hold off
axis equal;
