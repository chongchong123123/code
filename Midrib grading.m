% 输入点云文件路径
pointCloudFile = 'D:\dianyun\yansefenge\123123.pcd'; % 替换为你的点云文件路径

% 从文件加载点云数据
pointCloud = pcread(pointCloudFile);

% 1. 将点云数据按照 Z 轴坐标进行排序
sortedPointCloud = sortrows(pointCloud.Location, 3);

% 2. 将点云数据分成三等分
numPoints = size(sortedPointCloud, 1);
third = round(numPoints / 3);

% 第一等分
part1 = sortedPointCloud(1:third, :);

% 第二等分
part2 = sortedPointCloud(third+1:2*third, :);

% 第三等分
part3 = sortedPointCloud(2*third+1:end, :);

% 3. 计算每个部分的厚度和宽度
% 假设厚度为 Z 轴上的距离
thicknessPart1 = max(part1(:, 3)) - min(part1(:, 3));
thicknessPart2 = max(part2(:, 3)) - min(part2(:, 3));
thicknessPart3 = max(part3(:, 3)) - min(part3(:, 3));

% 假设宽度为 X 轴上的距离
widthPart1 = max(part1(:, 1)) - min(part1(:, 1));
widthPart2 = max(part2(:, 1)) - min(part2(:, 1));
widthPart3 = max(part3(:, 1)) - min(part3(:, 1));

% 4. 可视化部分，设置字体为新罗马加粗
figure;
subplot(1, 3, 1);
scatter3(part1(:, 1), part1(:, 2), part1(:, 3), '.');
title('Part 1', 'FontName', 'Times New Roman', 'FontWeight', 'bold');

subplot(1, 3, 2);
scatter3(part2(:, 1), part2(:, 2), part2(:, 3), '.');
title('Part 2', 'FontName', 'Times New Roman', 'FontWeight', 'bold');

subplot(1, 3, 3);
scatter3(part3(:, 1), part3(:, 2), part3(:, 3), '.');
title('Part 3', 'FontName', 'Times New Roman', 'FontWeight', 'bold');

% 显示厚度和宽度（对这部分不需要特别字体设置）
disp('Part 1 Thickness:');
disp(thicknessPart1);
disp('Part 1 Width:');
disp(widthPart1);

disp('Part 2 Thickness:');
disp(thicknessPart2);
disp('Part 2 Width:');
disp(widthPart2);

disp('Part 3 Thickness:');
disp(thicknessPart3);
disp('Part 3 Width:');
disp(widthPart3);