% LQR test code, to get every single time control input. 肉眼看是不是合理的控制量
% Parameters
L = 2.7; % 车辆轴距
v_target = 10; % 目标车速

% 目标位置和航向角
x_target = 100;
y_target = 100;
theta_target = 0;

% 状态转移矩阵 A
A = [0 0 -v_target*sin(theta_target);
     0 0 v_target*cos(theta_target);
     0 0 0];

% 输入矩阵 B
B = [cos(theta_target) 0;
     sin(theta_target) 0;
     0 v_target/L];

% 权重矩阵 Q, R
Q = diag([1, 1, 0.01]); % 调节位置和航向角的权重
R = 0.01; % 控制输入的权重

% 解 Riccati 方程得到 P
P = care(A, B, Q, R);

% 计算控制增益矩阵 K
K = (R + B.' * P * B)^-1 * (B.' * P * A);

% Simulation
T = 10; % 总时间
dt = 0.01; % 时间步长
t = 0:dt:T; % 时间向量

% 初始状态
x = [0; 0; 0]; % 初始位置和航向角

% 目标状态
x_desired = [x_target; y_target; theta_target];

% 控制输入
u = zeros(2, length(t)-1);
 
for i = 1:length(t)-1
    % 计算状态偏差
    x_error = x_desired - x;
    
    % 计算控制输入
    u(:,i) = -K * x_error;
    
    % 更新状态
    x = x + dt * (A * x + B * u(:,i));
end

% 可视化结果
figure;
plot(t(1:end-1), u(1,:), 'r', 'LineWidth', 2);
hold on;
plot(t(1:end-1), u(2,:), 'b', 'LineWidth', 2);
xlabel('时间 (s)');
ylabel('车轮转角 (rad)');
legend('\delta_1', '\delta_2');
title('控制输入');

figure;
plot(x(1), x(2), 'ro', 'MarkerSize', 10); % 当前位置
hold on;
plot(x_desired(1), x_desired(2), 'gx', '
