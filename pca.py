import rips

# 创建 ResInsight 应用实例
app = rips.app()

# 获取当前项目
project = app.project()

# 获取第一个网格模型
grid_model = project.grid_model(0)  # 根据实际情况选择正确的网格模型索引

# 获取所有网格单元
cells = grid_model.cells()

# 定义细分逻辑
def subdivide_cell(cell):
    # 实现实际的网格细分逻辑，这里是一个示例
    new_cells = []
    for i in range(4):  # 举例：细分为四个独立的小单元
        new_cells.append(cell.subdivide())
    return new_cells

# 进行细分
subdivided_cells = []
for cell in cells:
    subdivided_cells.extend(subdivide_cell(cell))

# 更新网格模型
grid_model.update_cells(subdivided_cells)

# 保存新模型到指定路径
save_path = "D:\\fenhua\\2\\subdivided_model.EGRID"  # Windows 路径示例
project.save_as(save_path)

# 输出结果
print(f"Number of original cells: {len(cells)}")
print(f"Number of subdivided cells: {len(subdivided_cells)}")
print(f"Subdivided model saved at: {save_path}")