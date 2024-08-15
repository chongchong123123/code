#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/point_cloud.h>
#include <pcl/filters/passthrough.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <boost/thread/thread.hpp>
using namespace std;
int
main()
{
	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_filtered(new pcl::PointCloud<pcl::PointXYZ>);
	pcl::io::loadPCDFile("2020.pcd", *cloud);
	cout << "加载点云" << cloud->points.size() << "个" << endl;
	// 创建滤波器对象
	pcl::PassThrough<pcl::PointXYZ> pass;
	pass.setInputCloud(cloud);
	pass.setFilterFieldName("z"); //滤波字段名被设置为Z轴方向
	pass.setFilterLimits(0.0, 1.0); //设置在过滤方向上的过滤范围
	// pass.setKeepOrganized(true); // 保持有序点云结构，该功能用于有序点云才有意义。
	pass.setNegative(true); //设置保留范围内的点还是过滤掉范围内的点，标志为false时保留范围内的点
	pass.filter(*cloud_filtered);

	cout << "Cloud after filtering: " << cloud_filtered->points.size() << endl;
	boost::shared_ptr<pcl::visualization::PCLVisualizer> view(new pcl::visualization::PCLVisualizer("ShowCloud"));

	int v1(0);
	view->createViewPort(0.0, 0.0, 0.5, 1.0, v1);
	view->setBackgroundColor(0, 0, 0, v1);
	view->addText("Raw point clouds", 10, 10, "v1_text", v1);
	int v2(0);
	view->createViewPort(0.5, 0.0, 1, 1.0, v2);
	view->setBackgroundColor(0.1, 0.1, 0.1, v2);
	view->addText("filtered point clouds", 10, 10, "v2_text", v2);

	view->addPointCloud<pcl::PointXYZ>(cloud, "sample cloud", v1);
	view->addPointCloud<pcl::PointXYZ>(cloud_filtered, "cloud_filtered", v2);
	view->setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_COLOR, 1, 0, 0, "sample cloud", v1);
	view->setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_COLOR, 0, 1, 0, "cloud_filtered", v2);
	//view->addCoordinateSystem(1.0);
	//view->initCameraParameters();
	while (!view->wasStopped())
	{
		view->spinOnce(100);
		boost::this_thread::sleep(boost::posix_time::microseconds(100000));
	}

	return 0;
}
