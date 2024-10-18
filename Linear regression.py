import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

weights = np.array([])
plant_height = np.array([])
plant_spread = np.array([])

# 建立输入矩阵
X = np.column_stack((plant_height, plant_spread))
y = weights

# 创建线性回归模型
model = LinearRegression()
model.fit(X, y)

# 预测值
y_pred = model.predict(X)

# 计算 R² 和 RMSE
r_squared = r2_score(y, y_pred)
rmse = np.sqrt(mean_squared_error(y, y_pred))

# 设置图形
fig = plt.figure(figsize=(12, 9))
ax = fig.add_subplot(111, projection='3d')

# 绘制散点图
ax.scatter(plant_height, plant_spread, weights, color='b', s=100, label='Actual Data')

# 绘制回归平面
x_surf, y_surf = np.meshgrid(np.linspace(20, 70, 100), np.linspace(20, 60, 100))
z_surf = model.intercept_ + model.coef_[0] * x_surf + model.coef_[1] * y_surf
ax.plot_surface(x_surf, y_surf, z_surf, color='r', alpha=0.3)

# 设置标签
ax.set_title('Regression of Cabbage Weight on Plant Height and Spread', fontsize=30, fontname='Times New Roman', pad=20)
ax.set_xlabel('Plant Height', fontsize=30, fontname='Times New Roman', labelpad=10)
ax.set_ylabel('Plant Spread', fontsize=30, fontname='Times New Roman', labelpad=10)
ax.set_zlabel('Cabbage Weight', fontsize=30, fontname='Times New Roman', labelpad=10)
ax.tick_params(axis='both', which='major', labelsize=16)

# 在图形上添加文本信息
equation_text = f'Weight = {model.intercept_:.2f} + {model.coef_[0]:.2f} * Height + {model.coef_[1]:.2f} * Spread'
stat_text = f'R² = {r_squared:.2f}\nRMSE = {rmse:.2f} kg'  # 添加单位
ax.text2D(0.05, 0.95, equation_text, transform=ax.transAxes, fontsize=20, fontname='Times New Roman', verticalalignment='top', bbox=dict(boxstyle="round,pad=0.5", edgecolor='black', facecolor='wheat', alpha=0.7))
ax.text2D(0.05, 0.88, stat_text, transform=ax.transAxes, fontsize=20, fontname='Times New Roman', verticalalignment='top', bbox=dict(boxstyle="round,pad=0.5", edgecolor='black', facecolor='wheat', alpha=0.7))

# 调整图例位置
plt.legend(fontsize=18, loc='upper right')
plt.tight_layout()
plt.show()