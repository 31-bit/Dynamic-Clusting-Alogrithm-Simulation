% 检验真实数据target_point 数据是否计算合理
a_csvFilePath = 'CAN_A_00000000_2024年4月11日.csv';
[time,hour,minutes,seconds,target_x, target_y, a_origin_LLA_z,poly_term0,poly_term1,...
    a_veh_x,a_veh_y, a_control_angle,a_lateral_error, a_heading_error,poly_term2,a_heading] = readvars(a_csvFilePath);
%% 实时绘制，当新一个坐标点出现时，拟合曲线的状态和预期target_point坐标
fg = figure(1);
% 设置figure的宽度和高度，单位为英寸
set(gcf, 'Position', [10, 10, 1500, 700]); % 位置[x, y, 宽度, 高度]

hold on;
xmin = -2; xmax =15; ymin = -3; ymax = 3;
axis equal;
axis([xmin,xmax,ymin,ymax]);
DIST_OF_TARGET_IN_X = 3;
for i = 5: length(a_veh_x)
    % 绘制第i个点
    x = a_veh_x(1:i);
    y = a_veh_y(1:i);
    
    if a_veh_x(i) == a_veh_x(i-1)
        continue
    end
    scatter(x, y, 'black','filled');
    hold on;
    axis([xmin,xmax,ymin,ymax]);
    axis equal;
    scatter(target_x(i),target_y(i));

        % 多项式拟合
    coefficients = [poly_term2(i),poly_term1(i),poly_term0(i)];
    
    % 生成拟合后的曲线 
    x_fit = linspace(target_x(i)-6, target_x(i), 1000); % 生成用于绘制曲线的更多点
    y_fit = polyval(coefficients, x_fit);
    plot(x_fit, y_fit, '-', 'DisplayName', '拟合曲线');

    hold off;
    pause(0.5);
end