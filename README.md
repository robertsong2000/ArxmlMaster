# AUTOSAR ARXML 解析和验证工具

这个项目提供了用于解析和验证 AUTOSAR 4.0.3 标准 ARXML 文件的 Go 语言工具。

## 功能特性

- ✅ **完整的 AUTOSAR 4.0.3 数据结构定义**
- ✅ **ARXML 文件解析**：支持从文件或字节数据解析 ARXML
- ✅ **数据验证**：验证 ARXML 数据的结构和完整性
- ✅ **详细的错误报告**：提供错误、警告和信息级别的验证结果
- ✅ **命令行工具**：便于集成到 CI/CD 流程中
- ✅ **Go 语言 API**：支持在 Go 程序中直接使用

## 项目结构

```
ArxmlMaster/
├── Autosar403/                  # AUTOSAR 4.0.3 包
│   ├── Autosar403.go           # 完整的数据结构定义和解析功能
│   └── doc.go                  # 包文档
├── Autosar321/                  # AUTOSAR 3.2.1 包
│   ├── Autosar321.go           # 数据结构定义
│   └── doc.go                  # 包文档
├── cmd/                         # 命令行工具
│   └── arxml-validator/        # ARXML 验证工具
│       └── main.go
├── example.go                   # 使用示例
└── README.md                   # 本文档
```

## 安装和使用

### 作为 Go 包使用

1. 将项目克隆到你的 Go 工作空间：
```bash
git clone <repository-url> ArxmlMaster
cd ArxmlMaster
```

2. 在你的 Go 程序中导入：
```go
import "path/to/ArxmlMaster/Autosar403"
```

### 作为命令行工具使用

首先确保项目在 Go 模块模式下：
```bash
go mod init arxmlmaster  # 如果还没有初始化
```

编译命令行工具：
```bash
go build -o arxml-validator ./cmd/arxml-validator
```

使用工具验证 ARXML 文件：
```bash
./arxml-validator -file examples/basic_example.arxml
```

## API 使用示例

### 基本解析和验证

```go
package main

import (
    "fmt"
    "log"
    "path/to/ArxmlMaster/Autosar403"
)

func main() {
    // 解析 ARXML 文件
    autosar, err := Autosar403.ParseArxmlFile("examples/basic_example.arxml")
    if err != nil {
        log.Fatalf("解析失败: %v", err)
    }

    // 验证 ARXML 数据
    result := Autosar403.ValidateArxml(autosar)

    // 打印验证结果
    result.PrintValidationResult()

    // 检查是否有错误
    if result.HasErrors() {
        fmt.Println("发现错误，需要修复")
        for _, err := range result.Errors {
            fmt.Printf("- [%s] %s\n", err.Element, err.Message)
        }
    }
}
```

### 从字节数据解析

```go
arxmlData := []byte(`<?xml version="1.0" encoding="UTF-8"?>
<AUTOSAR xmlns="http://autosar.org/schema/r4.0" S="R4.0.3">
  <AR-PACKAGES>
    <AR-PACKAGE>
      <SHORT-NAME>MyPackage</SHORT-NAME>
    </AR-PACKAGE>
  </AR-PACKAGES>
</AUTOSAR>`)

autosar, err := Autosar403.ParseArxmlData(arxmlData)
if err != nil {
    log.Fatalf("解析失败: %v", err)
}

result := Autosar403.ValidateArxml(autosar)
```

## 命令行工具使用

### 基本用法

```bash
# 验证 ARXML 文件
./arxml-validator -file path/to/your/file.arxml

# 使用简写参数
./arxml-validator -f path/to/your/file.arxml

# 以 JSON 格式输出结果
./arxml-validator -file examples/basic_example.arxml -json

# 显示帮助信息
./arxml-validator -help
```

### 退出码

- `0` - 验证成功（无错误）
- `1` - 验证失败或有错误

## 验证规则

### 基本验证

1. **根级别结构**：
   - 检查 AUTOSAR 元素是否存在
   - 验证必需的 S 属性（命名空间）
   - 验证时间戳 T 属性

2. **AR-PACKAGE 验证**：
   - 检查必需的 SHORT-NAME 字段
   - 验证 SHORT-NAME 格式（字母开头，只能包含字母、数字和下划线）
   - 验证 SHORT-NAME-PATTERN（如果存在）

3. **标识符验证**：
   - AUTOSAR 标识符必须以字母开头
   - 只能包含字母、数字和下划线
   - 不能为空

### 验证结果级别

- **ERROR**：严重问题，必须修复
- **WARNING**：潜在问题，建议检查
- **INFO**：信息性消息

## 示例 ARXML

有效的 ARXML 文件示例：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<AUTOSAR xmlns="http://autosar.org/schema/r4.0" S="R4.0.3">
  <AR-PACKAGES>
    <AR-PACKAGE>
      <SHORT-NAME>MyPackage</SHORT-NAME>
      <SHORT-NAME-PATTERN>MyPattern*</SHORT-NAME-PATTERN>
      <ELEMENTS>
        <SYSTEM>
          <SHORT-NAME>MySystem</SHORT-NAME>
        </SYSTEM>
      </ELEMENTS>
    </AR-PACKAGE>
  </AR-PACKAGES>
</AUTOSAR>
```

## 扩展开发

### 添加新的验证规则

要添加新的验证规则，可以：

1. 在相应的验证函数中添加逻辑
2. 使用现有的工具函数：
   - `validateShortName()` - 验证 SHORT-NAME 字段
   - `validateReference()` - 验证引用字段
   - `isValidIdentifier()` - 检查标识符格式

3. 添加新的 `ValidationError` 到结果中

### 支持新的 AUTOSAR 元素

当前支持的主要元素包括：
- AUTOSAR 根元素
- AR-PACKAGE
- SYSTEM
- 基本的标识符和引用验证

要支持更多元素类型，需要：
1. 查找相应的结构体定义
2. 在 `validateElements()` 函数中添加验证逻辑
3. 创建专门的验证函数

## 支持的 AUTOSAR 版本

- AUTOSAR 4.0.3 (完整支持，包含验证功能)
- AUTOSAR 3.2.1 (基础结构定义)

## 限制和注意事项

1. **版本支持**：当前主要支持 AUTOSAR 4.0.3 标准
2. **完整验证**：当前提供基础验证，完整验证规则需要根据具体需求扩展
3. **性能**：大型 ARXML 文件可能需要优化内存使用
4. **XML 格式**：期望符合 AUTOSAR 标准的格式

## 快速开始

1. **解析和验证单个文件**：
```go
go run example.go
```

2. **编译命令行工具**：
```bash
go build -o arxml-validator ./cmd/arxml-validator
./arxml-validator -file your_file.arxml
```

3. **集成到你的项目**：
```go
import "ArxmlMaster/Autosar403"
autosar, _ := Autosar403.ParseArxmlFile("your_file.arxml")
result := Autosar403.ValidateArxml(autosar)
```

## 📁 项目文件结构

```
ArxmlMaster/
├── .gitignore                   # Git 忽略文件配置
├── Autosar403/                  # AUTOSAR 4.0.3 包
│   ├── Autosar403.go           # 主要实现文件
│   └── doc.go                  # 包文档
├── Autosar321/                  # AUTOSAR 3.2.1 包
├── cmd/                         # 命令行工具
│   └── arxml-validator/        # ARXML 验证工具
├── examples/                    # 示例 ARXML 文件
│   ├── basic_example.arxml      # 基础示例
│   ├── complete_valid_example.arxml
│   ├── common_errors_example.arxml
│   ├── vehicle_config_example.arxml
│   ├── vehicle_configuration_example.arxml
│   ├── software_components_example.arxml
│   ├── communication_example.arxml
│   ├── bad_example.arxml        # 错误示例
│   ├── partial_bad_example.arxml
│   ├── invalid_example.arxml
│   └── README.md               # 示例说明
├── *.go                         # 主要 Go 源文件
├── *.sh                         # 自动化脚本
├── *.md                         # 文档文件
├── go.mod                       # Go 模块文件
└── arxml-validator              # 编译产物（被 .gitignore 忽略）
```

**注意**: 编译产物如 `arxml-validator` 可执行文件已被 `.gitignore` 忽略，使用时需要自行编译。

## 许可证

MIT License

---

*这是一个专门用于汽车电子开发的工具，帮助开发者处理 AUTOSAR 标准的 ARXML 文件。*