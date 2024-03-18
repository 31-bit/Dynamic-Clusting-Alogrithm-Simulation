% double click, manually load data and run this code
% save data in nominal variable
time = VarName1;
origin_LLH = [VarName5(10);VarName6(10);VarName7(10)];      % 东北天原点坐标
recent_point = [VarName8,VarName14];                        % 程序中选择出的玉米杆位置
realtime_point = [VarName9,VarName10];                      % 探测杆末端实时数据
u = VarName11;                                              % 下发控制量航向角实时数据
referance_a = [f,af];                                       % 新的recent point 出现时拟合AB线的a点坐标
referance_b = [VarName15, VarName16];                       % 新的recent point 出现时拟合AB线的b点坐标

clear VarName1
clear VarName2
clear VarName3
clear VarName4
clear VarName5
clear VarName6
clear VarName7
clear VarName8
clear VarName9
clear VarName10
clear VarName11
clear f
clear af
clear VarName14
clear VarName15
clear VarName16

