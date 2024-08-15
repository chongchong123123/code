clc; clear;

%% --------------------------加载点云数据--------------------------------
ptCloud = pcread('D:\dianyun\1234567.pcd');
loc = ptCloud.Location;

%% ---------------------------二维显示-----------------------------------
figure
scatter(loc(:,1), loc(:,2), '.');
title('点云的二维显示')
hold on

%% ---------------------------Kmeans聚类-----------------------------------
numClusters = 5; % 设置聚类个数为 5，代表九棵白菜
[idx, C] = kmeans(loc, numClusters);

% 可视化聚类结果和聚类中心。
figure;
colors = hsv(numClusters); % 生成不同颜色以区分不同类别
for k = 1:numClusters
    plot(loc(idx==k,1), loc(idx==k,2), '.', 'Color', colors(k,:), 'MarkerSize', 5);
    hold on;
end
plot(C(:,1), C(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 3);
legend('白菜 1', '白菜 2', '白菜 3', '白菜 4', '白菜 5', '白菜 6', '白菜 7', '白菜 8', '白菜 9', '聚类中心', 'Location', 'NW');
title('聚类结果和聚类中心点');
hold off;

%% ------------------------聚类结果分类保存-------------------------------
% 获取聚类索引
cluster_idx = unique(idx);

for num = 1:numClusters
    idxPoints = find(idx == cluster_idx(num)); % 根据聚类标签查找点
    segmented = select(ptCloud, idxPoints); % 根据索引提取 
    filename = strcat('cabbage_cluster_', num2str(num), '.pcd');
    pcwrite(segmented, filename, 'Encoding', 'binary'); % 保存结果到本地文件夹
end