#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/filters/statistical_outlier_removal.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <boost/thread/thread.hpp>
using namespace std;

void VisualizeCloud(pcl::PointCloud<pcl::PointXYZ>::Ptr& cloud, pcl::PointCloud<pcl::PointXYZ>::Ptr& filter_cloud) {
	//-----------------------��ʾ����-----------------------
	boost::shared_ptr<pcl::visualization::PCLVisualizer> viewer(new pcl::visualization::PCLVisualizer("��ʾ����"));

	int v1(0), v2(0);
	viewer->createViewPort(0.0, 0.0, 0.5, 1.0, v1);
	viewer->setBackgroundColor(0, 0, 0, v1);
	viewer->addText("point clouds", 10, 10, "v1_text", v1);
	viewer->createViewPort(0.5, 0.0, 1, 1.0, v2);
	viewer->setBackgroundColor(0.1, 0.1, 0.1, v2);
	viewer->addText("filtered point clouds", 10, 10, "v2_text", v2);
	// ����z�ֶν�����Ⱦ,��z��Ϊx��y��Ϊ����x��y�ֶ���Ⱦ
	pcl::visualization::PointCloudColorHandlerGenericField<pcl::PointXYZ> fildColor(cloud, "z");
	viewer->addPointCloud<pcl::PointXYZ>(cloud, fildColor, "sample cloud", v1);

	viewer->addPointCloud<pcl::PointXYZ>(filter_cloud, "cloud_filtered", v2);
	viewer->setPointCloudRenderingProperties(pcl::visualization::PCL_VISUALIZER_COLOR, 0, 1, 0, "cloud_filtered", v2);
	//viewer->addCoordinateSystem(1.0);
	//viewer->initCameraParameters();
	while (!viewer->wasStopped())
	{
		viewer->spinOnce(100);
		boost::this_thread::sleep(boost::posix_time::microseconds(100000));
	}
}

int
main()
{
	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_filtered(new pcl::PointCloud<pcl::PointXYZ>);
	//�����������
	pcl::PCDReader reader;
	reader.read<pcl::PointXYZ>("Test.pcd", *cloud);
	cout << "Cloud before filtering:\n " << *cloud << endl;
	// -----------------ͳ���˲�-------------------
	// �����˲�������ÿ����������ٽ���ĸ�������Ϊ50 ��������׼��ı�������Ϊ1  ����ζ�����һ
	// ����ľ��볬����ƽ������һ����׼�����ϣ���õ㱻���Ϊ��Ⱥ�㣬�������Ƴ����洢����
	pcl::StatisticalOutlierRemoval<pcl::PointXYZ> sor;
	sor.setInputCloud(cloud);   //���ô��˲��ĵ���
	sor.setMeanK(50);           //�����ڽ���ͳ��ʱ���ǲ�ѯ���ڽ�����
	sor.setStddevMulThresh(1);  //�����ж��Ƿ�Ϊ��Ⱥ�����ֵ����ߵ����ֱ�ʾ��׼��ı�����1����׼�����Ͼ�����Ⱥ�㡣
	//�������жϵ��k����ƽ������(mean distance)����ȫ�ֵ�1����׼��+ƽ������(global distances mean and standard)����Ϊ��Ⱥ�㡣


	sor.filter(*cloud_filtered); //�洢�ڵ�
	cout << "Cloud after filtering: \n" << *cloud_filtered << endl;
	// �������
	pcl::PCDWriter writer;
	// writer.write<pcl::PointXYZ> ("inliers.pcd", *cloud_filtered, true);
	 // ���ӻ�
	VisualizeCloud(cloud, cloud_filtered);

	return (0);
}

