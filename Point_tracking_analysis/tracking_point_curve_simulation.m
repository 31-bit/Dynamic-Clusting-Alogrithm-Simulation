
% 测试target point 过弯预期效果

clear all;
close all;
a_csvFilePath = 'Corn_pos_low_speed1km_a.csv';
%% 生成直线部分点的坐标
curve_radius = 10; % 曲率最大的地方的半径

% 设置 x 的范围和间距
x_stright = -5:0.3:0;
% 生成理想的 y 值，这里假设为 6 附近
y_ideal = curve_radius; % 曲率最大的地方的半径 + 0.0 * x_stright; 
% 设置纵向误差的标准差
vertical_error_std = 0.06;
% 生成正态分布的随机误差
vertical_error = vertical_error_std * randn(size(x_stright));
% 添加误差到理想的 y 值上
y_stright = y_ideal + vertical_error;

% 绘制直线
% figure(1);
% errorbar(x_stright, y_stright, vertical_error_std, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
% xlabel('x');
% ylabel('y');
% title('Generated Data with Normal Distribution Error');
% grid on;
%% 生成曲线部分点的坐标
num_points = 200; % 点的数量


% 生成 x 坐标
theta = linspace(0, 2*pi, num_points);
x = curve_radius * cos(theta);
% 生成 y 坐标
y = curve_radius * sin(theta);

% 添加噪声以模拟测量误差
noise_level = 0.06;
x = x + noise_level * randn(size(x));
y = y + noise_level * randn(size(y));
%% 将直线和曲线的点拼接
a_corn_x = [x_stright, x(27*2:-1:1)];
a_corn_y = [y_stright, y(27*2:-1:1)];

%% 实时绘制，当新一个坐标点出现时，拟合曲线的状态和预期target_point坐标
fg = figure(1);
% 设置figure的宽度和高度，单位为英寸
set(gcf, 'Position', [100, 100, 1500, 800]); % 位置[x, y, 宽度, 高度]

hold on;
xmin = -6; xmax =20; ymin = -7; ymax = 7;
axis equal;
axis([xmin,xmax,ymin,ymax]);


% 多项式拟合的项数
degree = 2; % 这里是一个示例，可以根据需要修改
NUM_POINTS_FOR_FIT = 20;
DIST_OF_TARGET_IN_X = 2;
% clear duplicate corn point position
corn_pos =[a_corn_x(1), a_corn_y(1)];
for i = 2:length(a_corn_x)
    if a_corn_x(i) ~= corn_pos(end,1)
        corn_pos = [corn_pos; a_corn_x(i), a_corn_y(i)]
    end
end
line = []
angle_at_target_all  = [];
for i = 5: length(corn_pos)
    % 绘制第i个点
    x = corn_pos(1:i,1);
    y = corn_pos(1:i,2);
    scatter(x, y, 'black','filled');
    hold on;
    axis([xmin,xmax,ymin,ymax]);
    axis equal;
    line = [corn_pos(1:i, 1), corn_pos(1:i,2)];
    if  i > NUM_POINTS_FOR_FIT
        line = [corn_pos(i-NUM_POINTS_FOR_FIT:i, 1), corn_pos(i-NUM_POINTS_FOR_FIT:i,2)];
    end
    % 多项式拟合
    coefficients = polyfit(line(:,1), line(:,2), degree);
    
    % 生成拟合后的曲线 
    x_fit = linspace(min(line(:,1)), max(line(:,1) + DIST_OF_TARGET_IN_X), 1000); % 生成用于绘制曲线的更多点
    y_fit = polyval(coefficients, x_fit);
    plot(x_fit, y_fit, '-', 'DisplayName', '拟合曲线');
    pause(0.5);
    hold off;
    
    % 计算一阶导数，即斜率
    deriv_coeffs = [2*coefficients(1), coefficients(2)];
    
    % 假设你想要找到右侧2米处的点的 x 坐标
    % 假设原点处的 x 坐标为 x_origin
    x_current = corn_pos(i,1); 
    
    % 在特定点处计算斜率
    slope_at_origin = polyval(deriv_coeffs, x_current);
    
    % 定义距离，假设为 2 米
    distance = 2;
    
    % 根据斜率和距离计算新的 x 坐标
    % 新的 x 坐标 = 原点 x 坐标 + 距离 / sqrt(1 + 斜率^2)
    x_new = x_current + distance / sqrt(1 + slope_at_origin^2);
    slope_at_target =  polyval(deriv_coeffs, x_new);
    angle_at_target_all = [angle_at_target_all, atan(slope_at_target) * 180 / pi];

    % 如果不是最后一个点，清除前面的渐进线
    if i <length(corn_pos)
        scatter(x, y, 'black','filled');
        hold on;
        axis([xmin,xmax,ymin,ymax]);
        axis equal; 
        plot(x_fit,y_fit)
        hold off;
    end
end
%% 目标航向角度变化量，看看是否变化过大
figure(3);
title("target point heading angle")
plot(angle_at_target_all)

figure(4);
delta_heading_angle = [angle_at_target_all, angle_at_target_all(end)]- [angle_at_target_all(1),angle_at_target_all];
title("delta target point heading angle")
plot(delta_heading_angle)
%% 增加滤波
filter_angle = [];
for i = 3:length(angle_at_target_all)
    filter_angle = [ filter_angle,mean(angle_at_target_all(i-2:i)) ]
end
figure(5);
title("3点均值滤波后目标航向")
plot(filter_angle)

figure(6);
delta_filter_angle = [filter_angle, filter_angle(end)]- [filter_angle(1),filter_angle];
title("3点均值滤波后目标航向变化量")
plot(delta_filter_angle)

%% 预瞄计算每个点的车轮打角度
