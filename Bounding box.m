clc; clear;
%% ----------------------------读取点云----------------------------------
pc = pcread('D:\shiyan4.15\cabbage_cluster_1.pcd');
%% --------------------------获取xyz坐标---------------------------------
x = pc.Location(:,1);
y = pc.Location(:,2);
z = pc.Location(:,3);
Data = [x,y,z];

%% ----------------------------主成分分析--------------------------------
% 1、计算点云质心
centroid = mean(Data,1);
% 2、去质心化
deMean = bsxfun(@minus, Data, centroid);
% 3、构建协方差矩阵
cov = deMean' * deMean;
cov = cov / (size(Data,1) - 1);
% 4、协方差矩阵进行奇异值分解，获取特征向量
[~, ~, V] = svd(cov);
 %% -----------------------点云投影到特征空间----------------------------
% 1、构建投影变换矩阵
trans = centroid - centroid * V;
tform = rigid3d(V,trans);
% 2、变换点云
projected = pctransform(pc, tform);  
% 3、获取投影后点云在XYZ方向的最大值和最小值
xMax = projected.XLimits(2);
yMax = projected.YLimits(2);
zMax = projected.ZLimits(2);
xMin = projected.XLimits(1);
yMin = projected.YLimits(1);
zMin = projected.ZLimits(1);
% 计算点云在XYZ方向上的取值范围
dx = xMax - xMin;
dy = yMax - yMin;
dz = zMax - zMin;
%% ------------------------可视化点云和包围框----------------------------
pcshow(projected);
% 定义一个长方体，并以不透明度为0.1的黄色显示它。
pos = [xMin+dx/2, yMin+dy/2, zMin+dz/2, dx, dy, dz, 0, 0, 0];
showShape('cuboid', pos, 'Color', 'yellow', 'Opacity', 0.1);
title('\bf{PCA Constructed OBB Bounding Box}', 'FontName', 'Times New Roman')
%% ------------------------输出包围框的相关信息--------------------------
centerCoord = [xMin+dx/2, yMin+dy/2, zMin+dz/2] + centroid;
fprintf("\bf{Minimum Bounding Box}\n\bf{Length}: %f, \bf{Width}: %f, \bf{Height}: %f\n\bf{Center Coordinates}: (%f, %f, %f)\n",...
    dx, dy, dz, centerCoord(1), centerCoord(2), centerCoord(3));
Volume = dx * dy * dz;
Surface = 2 * (dx * dy + dx * dz + dy * dz);
fprintf("\bf{Volume of the Box}: %f\n\bf{Surface Area of the Box}: %f\n", Volume, Surface);
