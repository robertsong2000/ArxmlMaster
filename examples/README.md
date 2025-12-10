# ARXML 示例文件集合

本目录包含了各种类型的 AUTOSAR ARXML 示例文件，用于测试和演示 ARXML 解析和验证工具。

## 📁 文件列表

### ✅ 有效示例文件

#### 1. `basic_example.arxml`
- **类型**: 基础示例文件
- **内容**: 简单的 AUTOSAR 系统和包定义
- **用途**: 快速入门和基础功能测试
- **验证结果**: ✓ 有效

#### 2. `complete_valid_example.arxml`
- **类型**: 完整有效的 AUTOSAR 4.0.3 示例
- **内容**: 包含基本系统、数据类型和软件组件定义
- **用途**: 验证工具的正常功能
- **验证结果**: ✓ 有效
- **特点**:
  - 正确的命名空间 (S="R4.0.3")
  - 包含时间戳 (T 属性)
  - 完整的元素结构
  - 有效的 SHORT-NAME 格式

#### 2. `vehicle_configuration_example.arxml`
- **类型**: 汽车配置相关示例
- **内容**: 车身控制、动力总成和底盘系统配置
- **验证结果**: ✓ 有效
- **包含元素**:
  - ECU 配置 (ECM_ECU, BCM_ECU, BRM_ECU, ICM_ECU)
  - 系统映射
  - 应用定时事件
  - 车辆数据类型 (车速、发动机转速、油门踏板等)

#### 3. `software_components_example.arxml`
- **类型**: 软件组件相关示例
- **内容**: 应用软件组件、服务接口和内部行为定义
- **验证结果**: ✓ 有效
- **包含元素**:
  - 数据类型定义
  - Client-Server 接口
  - Sender-Receiver 接口
  - 可运行实体 (Runnable Entities)
  - 定时事件和数据事件

#### 4. `communication_example.arxml`
- **类型**: 通信相关示例
- **内容**: CAN、以太网通信配置和信号定义
- **验证结果**: ✓ 有效
- **包含元素**:
  - CAN 总线配置
  - CAN 帧和信号定义
  - 系统信号
  - 物理通道配置

### ❌ 错误示例文件

#### 5. `bad_example.arxml`
- **类型**: 包含错误的示例文件
- **内容**: 包含 XML 语法错误和 AUTOSAR 结构问题
- **验证结果**: ✗ 无级
- **包含错误**:
  - XML 标签未闭合
  - 缺少必需属性
  - 无效的元素引用

#### 6. `partial_bad_example.arxml`
- **类型**: 部分错误的示例文件
- **内容**: 包含部分结构问题的 ARXML
- **验证结果**: ✗ 无效
- **用途**: 测试容错解析能力

#### 7. `invalid_example.arxml`
- **类型**: 完全无效的示例文件
- **内容**: 严重结构错误的 ARXML
- **验证结果**: ✗ 无效
- **用途**: 测试错误处理的边界情况

#### 8. `common_errors_example.arxml`
- **类型**: 包含常见错误的示例
- **内容**: 故意包含各种 AUTOSAR 错误
- **验证结果**: ✗ 无效 (4个错误, 1个警告)
- **包含错误**:
  - 缺少 S 属性（命名空间）
  - 无效的 SHORT-NAME 格式 (数字开头)
  - 空的 SHORT-NAME
  - 包含特殊字符的 SHORT-NAME
  - 缺少 T 属性（时间戳）

## 🔍 验证工具测试

### 使用命令行工具测试所有示例:

```bash
# 测试有效文件
./arxml-validator -file examples/complete_valid_example.arxml
./arxml-validator -file examples/vehicle_configuration_example.arxml
./arxml-validator -file examples/software_components_example.arxml
./arxml-validator -file examples/communication_example.arxml

# 测试错误文件
./arxml-validator -file examples/common_errors_example.arxml
```

### 测试结果统计:

| 文件 | 解析状态 | 验证状态 | 错误数 | 警告数 | 状态 |
|------|----------|----------|--------|--------|------|
| basic_example.arxml | ✅ | ✅ | 0 | 0 | ✓ 有效 |
| complete_valid_example.arxml | ✅ | ✅ | 0 | 0 | ✓ 有效 |
| vehicle_config_example.arxml | ✅ | ✅ | 0 | 0 | ✓ 有效 |
| vehicle_configuration_example.arxml | ✅ | ✅ | 0 | 0 | ✓ 有效 |
| software_components_example.arxml | ✅ | ✅ | 0 | 0 | ✓ 有效 |
| communication_example.arxml | ✅ | ✅ | 0 | 0 | ✓ 有效 |
| bad_example.arxml | ✅ | ❌ | 3+ | 1+ | ✗ 无效 |
| partial_bad_example.arxml | ✅ | ❌ | 1+ | 1+ | ✗ 无效 |
| invalid_example.arxml | ✅ | ❌ | 1+ | 1+ | ✗ 无效 |
| common_errors_example.arxml | ✅ | ❌ | 4 | 1 | ✗ 无效 |

## 📊 验证功能覆盖

### ✅ 已验证的功能:
- XML 语法解析
- AUTOSAR 命名空间检查
- SHORT-NAME 格式验证
- 时间戳属性检查
- 基本结构完整性

### 🔧 可扩展的验证功能:
- 数据类型完整性检查
- 引用完整性验证
- 端口连接验证
- 值范围检查
- 必需元素存在性验证

## 🚀 使用建议

### 对于开发者:
1. **学习 AUTOSAR**: 查看有效示例了解正确的 ARXML 结构
2. **调试 ARXML**: 使用错误示例了解常见问题和解决方案
3. **工具测试**: 使用这些文件测试您的 ARXML 处理工具

### 对于测试:
1. **正向测试**: 使用有效文件验证工具的基本功能
2. **负向测试**: 使用错误文件验证工具的错误检测能力
3. **边界测试**: 可以创建更多边界情况示例

## 📝 扩展示例

您可以根据需要创建更多类型的示例:
- **诊断相关**: 包含诊断服务的 ARXML
- **安全相关**: 包含安全机制配置的 ARXML
- **网络配置**: 更复杂的网络拓扑配置
- **大型系统**: 包含数百个组件的企业级示例
- **版本迁移**: 不同 AUTOSAR 版本的转换示例

## 🛠️ 生成更多示例

```bash
# 使用 JSON 输出进行详细分析
./arxml-validator -file examples/complete_valid_example.arxml -json

# 测试多个文件
for file in examples/*.arxml; do
    echo "Testing $file:"
    ./arxml-validator -file "$file"
    echo "-------------------"
done
```

---

这些示例文件为 ARXML 解析和验证工具提供了全面的测试覆盖，帮助您理解和验证 AUTOSAR 标准的实现。