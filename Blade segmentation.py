import open3d as o3d
import numpy as np
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

def load_point_cloud(file_path):
    """
    从给定路径加载PCD格式的点云文件
    """
    pcd = o3d.io.read_point_cloud(file_path)
    print(f"Loaded point cloud with {len(pcd.points)} points.")
    return pcd

def visualize_point_cloud(pcd):
    """
    可视化点云数据
    """
    o3d.visualization.draw_geometries([pcd])

def pca_analysis(pcd):
    """
    对点云数据执行主成分分析（PCA）
    """
    points = np.asarray(pcd.points)
    pca = PCA(n_components=3)
    pca.fit(points)
    
    # 转换点云到主成分坐标系
    transformed_points = pca.transform(points)
    
    # 输出主成分的方差
    print(f"Explained variance ratio: {pca.explained_variance_ratio_}")
    
    return transformed_points, pca

def divide_point_cloud_by_z_axis(pcd, transformed_points):
    """
    沿着z轴将点云等分成三份
    """
    z_values = transformed_points[:, 2]
    
    # 计算z轴的最小值、最大值和等分点
    z_min, z_max = np.min(z_values), np.max(z_values)
    z_split1 = z_min + (z_max - z_min) / 3
    z_split2 = z_min + 2 * (z_max - z_min) / 3
    
    # 创建新的点云用于存储分割结果
    part1 = pcd.select_by_index(np.where(z_values <= z_split1)[0])
    part2 = pcd.select_by_index(np.where((z_values > z_split1) & (z_values <= z_split2))[0])
    part3 = pcd.select_by_index(np.where(z_values > z_split2)[0])
    
    return part1, part2, part3

def visualize_divided_parts(part1, part2, part3):
    """
    可视化分割后的三部分点云
    """
    part1.paint_uniform_color([1, 0, 0])  # 红色
    part2.paint_uniform_color([0, 1, 0])  # 绿色
    part3.paint_uniform_color([0, 0, 1])  # 蓝色
    
    o3d.visualization.draw_geometries([part1, part2, part3])

def save_divided_parts(part1, part2, part3, output_dir):
    """
    保存分割后的点云部分
    """
    o3d.io.write_point_cloud(f"{output_dir}/part1.pcd", part1)
    o3d.io.write_point_cloud(f"{output_dir}/part2.pcd", part2)
    o3d.io.write_point_cloud(f"{output_dir}/part3.pcd", part3)
    print(f"Saved divided point clouds to {output_dir}.")

def calculate_midrib_width(transformed_points, pcd):
    """
    根据xy平面上的点计算中肋宽度
    """
    xy_plane = transformed_points[:, :2]
    
    # 切片分析
    num_slices = 100
    slice_widths = []
    z_values = transformed_points[:, 2]
    z_min, z_max = np.min(z_values), np.max(z_values)
    z_slices = np.linspace(z_min, z_max, num_slices)
    
    for i in range(len(z_slices) - 1):
        slice_indices = np.where((z_values >= z_slices[i]) & (z_values < z_slices[i + 1]))[0]
        if len(slice_indices) > 0:
            slice_points = xy_plane[slice_indices]
            width = np.ptp(slice_points[:, 0])  # 计算x方向的跨度
            slice_widths.append(width)
    
    avg_width = np.mean(slice_widths)
    print(f"Average midrib width: {avg_width:.2f}")
    
    # 绘制宽度变化
    plt.plot(slice_widths)
    plt.title('Midrib Width per Slice')
    plt.xlabel('Slice Index')
    plt.ylabel('Width')
    plt.show()

def main():
    # 加载点云
    file_path = "your_point_cloud_file.pcd"
    pcd = load_point_cloud(file_path)
    
    # 可视化原始点云
    visualize_point_cloud(pcd)
    
    # 主成分分析（PCA）
    transformed_points, pca = pca_analysis(pcd)
    
    # 沿z轴等分点云
    part1, part2, part3 = divide_point_cloud_by_z_axis(pcd, transformed_points)
    
    # 可视化分割后的点云部分
    visualize_divided_parts(part1, part2, part3)
    
    # 保存分割后的点云部分
    output_dir = "output_directory"
    save_divided_parts(part1, part2, part3, output_dir)
    
    # 计算中肋宽度
    calculate_midrib_width(transformed_points, pcd)

if __name__ == "__main__":
    main()