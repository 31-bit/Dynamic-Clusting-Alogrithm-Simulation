% % 输入数据
% x = recent_point(500:730,1); % 输入的x坐标
% y = recent_point(500:730,2); % 输入的y坐标

% 生成曲线上的点
num_points = 100; % 点的数量
curve_radius = 6; % 曲率最大的地方的半径

% 生成 x 坐标
theta = linspace(0, 2*pi, num_points);
x = curve_radius * cos(theta);

% 生成 y 坐标
y = curve_radius * sin(theta);

% 添加噪声以模拟测量误差
noise_level = 0.03;
x = x + noise_level * randn(size(x));
y = y + noise_level * randn(size(y));
% 
% x = [6.04,6.04,6.04, x(1:30)];
% y = [-1.5,-1.2,-0.9,y(1:30)];
num_points = length(x); % 输入点的数量

% 多项式拟合的项数
degree = 5; % 这里是一个示例，可以根据需要修改

% 多项式拟合
coefficients = polyfit(x, y, degree);

% 生成拟合后的曲线 
x_fit = linspace(min(x), max(x), 1000); % 生成用于绘制曲线的更多点
y_fit = polyval(coefficients, x_fit);

% 绘制原始数据和拟合曲线
figure;
plot(x(1:27), y(1:27), 'o', 'DisplayName', '原始数据');
hold on;
plot(x_fit, y_fit, '-', 'DisplayName', '拟合曲线');
legend('show');
xlabel('x'); 
ylabel('y');
title('高斯多项式拟合');

% 输出多项式系数
fprintf('拟合多项式系数:\n');
disp(coefficients);
