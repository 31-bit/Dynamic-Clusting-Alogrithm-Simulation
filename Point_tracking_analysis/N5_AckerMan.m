function K = N5_AckerMan(A, B, P)
    % 假设 A 是一个 5x5 的系统矩阵，B 是一个 5x1 的输入矩阵，P 是一个 5x1 的目标多项式系数向量
    % 计算可控矩阵
    Co = ctrb(A,B)
    % 计算可控矩阵的伪逆
    ctrb_inv = inv(Co);
    % 计算目标多项式的系数
    poly coeffs = P(:);
    % 计算多项式的贡献
    polyvalm = polyvalm(A, poly(coeffs));
    % 计算增益矩阵 K
    K = ctrb_inv * polyvalm;
    % 提取增益向量
    K = K(:);
end