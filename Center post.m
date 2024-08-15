% 读取PCD文件
pcd_file = 'D:\dianyun\zhu.pcd';
pcd_data = pcread(pcd_file);

% 提取点云数据
points = pcd_data.Location;

% 对点云进行PCA
[coeff, score, ~] = pca(points);

% 旋转点云到主成分坐标系
rotated_points = points * coeff;

% 分割点云：在新坐标系中基于z轴（第三主成分）
z_projection = rotated_points(:, 3); % 沿新的z轴
z_mean = mean(z_projection);

% 基于均值分割点云
upper_half = rotated_points(z_projection >= z_mean, :);
lower_half = rotated_points(z_projection < z_mean, :);

% 可视化新坐标系中的点云和分割
figure;
subplot(1, 3, 1);
pcshow(points);
title('Original Point Cloud');
xlabel('X');
ylabel('Y');
zlabel('Z');

subplot(1, 3, 2);
pcshow(rotated_points);
title('Point Cloud in PCA Coordinates');
xlabel('PCA X');
ylabel('PCA Y');
zlabel('PCA Z');

subplot(1, 3, 3);
hold on;
pcshow(upper_half, 'g');
pcshow(lower_half, 'r');
title('Segmented Point Cloud in PCA Coordinates');
xlabel('PCA X');
ylabel('PCA Y');
zlabel('PCA Z');
legend('Upper Half', 'Lower Half');
hold off;

% 输出相关信息
fprintf('划分值（均值z坐标）: %.2f\n', z_mean);