clc; clear;
%% -------------------------------读入点云-------------------------------
pcFile = 'E:\point\11.2\d106.0.pcd';
pc = pcread(pcFile);
figure;
pcshow(pc, 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down', 'MarkerSize', 30);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Original Point Cloud');
grid on; 
axis equal;

%% ---------------------------点坐标转为double----------------------------
XYZ = double(pc.Location);

%% -----------------------------主成分分析--------------------------------
% 移除平均值
mu = mean(XYZ);
XYZ_centered = XYZ - mu;
% 计算协方差矩阵
cov_matrix = cov(XYZ_centered);
% 特征值分解
[V, D] = eig(cov_matrix);

% 计算点云排序(根据特征值大小)
[~, idx] = sort(diag(D), 'descend');
V = V(:, idx);

% 调整点云的方向与第一主成分对齐
XYZ_rotated = XYZ_centered * V;
XYZ_rotated = bsxfun(@plus, XYZ_rotated, mu);

%% ---------------------------计算凸包及其体积与面积---------------------------
[k1, volume] = convhull(XYZ_rotated);

% 重组凸包中的三角形顶点
A = XYZ_rotated(k1(:,1), :);
B = XYZ_rotated(k1(:,2), :);
C = XYZ_rotated(k1(:,3), :);

% 计算三角形面积
area = sum(triArea(A, B, C));

%% -----------------------------绘制旋转后的点云与凸包图---------------------
figure;
trisurf(k1, XYZ_rotated(:,1), XYZ_rotated(:,2), XYZ_rotated(:,3), 'FaceColor', 'cyan', 'FaceAlpha', 0.3);
axis off; % 关闭坐标轴显示
title(sprintf("3D Rotated Point Cloud Convex Hull - Area: %.2f, Volume: %.2f", area, volume));
xlabel('X'); ylabel('Y'); zlabel('Z');
grid on;
axis equal;

%% ------------------------------输出信息--------------------------------
fprintf("Area of convex hull: %.2f square units\n", area);
fprintf("Volume of convex hull: %.2f cubic units\n", volume);

%% -------------------------------辅助函数：计算三角形面积--------------------
function A = triArea(A, B, C)
    % 计算三角形面积
    crossProduct = cross(B - A, C - A);
    A = 0.5 * sqrt(sum(crossProduct.^2, 2));
end