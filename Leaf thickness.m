% 加载PCD格式的点云数据
ptCloud = pcread('D:\dianyun\yansefenge\1.pcd');

% 获取点云中的位置坐标
locations = ptCloud.Location;

% 执行PCA
[coeff, score, latent] = pca(locations);

% PCA旋转矩阵直接对点云应用
rotatedLocations = score;

% 分析旋转后的点云
x_rotated = rotatedLocations(:,1);
y_rotated = rotatedLocations(:,2);
z_rotated = rotatedLocations(:,3);

% 标记叶尖为Y轴坐标最大的点
[~, tipIndex] = max(x_rotated);
leafTip = rotatedLocations(tipIndex, :);

% 在Y轴的五分之三到五分之四选取十个点作为叶基
yRange = [max(y_rotated)*3/5, max(y_rotated)*4/5];
baseIndices = find(y_rotated > yRange(1) & y_rotated < yRange(2));
selectedBaseIndices = datasample(baseIndices, 10, 'Replace', false);
leafBasePoints = rotatedLocations(selectedBaseIndices, :);

% 计算每个叶基点到叶尖的距离并求平均值
distances = sqrt(sum((leafBasePoints - leafTip).^2, 2));
averageThickness = mean(distances);

% 可视化旋转后的点云及叶尖和部分叶基点的位置
figure;
scatter3(x_rotated, y_rotated, z_rotated, 12, 'filled');
hold on;
plot3(leafTip(1), leafTip(2), leafTip(3), 'r*', 'MarkerSize', 15); % Marking the leaf tip
plot3(leafBasePoints(:,1), leafBasePoints(:,2), leafBasePoints(:,3), 'bo', 'MarkerSize', 10); % Marking the base points
title('Rotated Point Cloud with Leaf Tip and Base Points');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
zlabel('Principal Component 3');
legend('Point Cloud', 'Leaf Tip', 'Base Points');
axis equal;
grid on;

% Output average thickness result
fprintf('Average distance (thickness) between leaf tip and base points: %.2f units\n', averageThickness);

% 输出平均厚度结果
fprintf('叶尖与叶基的平均距离（厚度）：%.2f 单位\n', averageThickness);