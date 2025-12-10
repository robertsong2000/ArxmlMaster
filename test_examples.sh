#!/bin/bash

# ARXML 示例文件批量测试脚本
# 用于测试 ./arxml-validator 工具处理各种 ARXML 文件的能力

echo "🔍 ARXML 验证工具示例文件测试"
echo "==================================="
echo

# 检查验证工具是否存在
if [ ! -f "./arxml-validator" ]; then
    echo "❌ 错误: 找不到 arxml-validator 工具"
    echo "请先编译工具: go build -o arxml-validator ./cmd/arxml-validator"
    exit 1
fi

# 统计变量
total_files=0
valid_files=0
invalid_files=0
parse_errors=0

# 测试函数
test_file() {
    local file="$1"
    local description="$2"

    echo "📁 测试文件: $file"
    echo "📝 描述: $description"
    echo "----------------------------------------"

    if [ ! -f "$file" ]; then
        echo "❌ 文件不存在: $file"
        echo
        return 1
    fi

    # 运行验证工具
    ./arxml-validator -file "$file" 2>&1
    local exit_code=$?

    echo
    total_files=$((total_files + 1))

    if [ $exit_code -eq 0 ]; then
        valid_files=$((valid_files + 1))
        echo "✅ 验证通过 (退出码: 0)"
    else
        invalid_files=$((invalid_files + 1))
        echo "❌ 验证失败 (退出码: $exit_code)"
    fi

    echo "==================================="
    echo
}

echo "开始测试 ARXML 示例文件..."
echo

# 测试所有示例文件
test_file "examples/basic_example.arxml" "基础示例文件"
test_file "examples/bad_example.arxml" "包含错误的示例文件"
test_file "examples/vehicle_config_example.arxml" "车辆配置示例文件"
test_file "examples/partial_bad_example.arxml" "部分错误的示例文件"
test_file "examples/invalid_example.arxml" "无效的示例文件"
test_file "examples/complete_valid_example.arxml" "完整有效的 AUTOSAR 4.0.3 示例"
test_file "examples/common_errors_example.arxml" "包含常见错误的示例"
test_file "examples/vehicle_configuration_example.arxml" "汽车配置相关示例"
test_file "examples/software_components_example.arxml" "软件组件相关示例"
test_file "examples/communication_example.arxml" "通信相关示例"

# 生成测试报告
echo "📊 测试报告"
echo "==================================="
echo "总文件数: $total_files"
echo "有效文件: $valid_files"
echo "无效文件: $invalid_files"
echo "解析错误: $parse_errors"
echo "成功率: $(( valid_files * 100 / total_files ))%"
echo

# JSON 输出示例
echo "🔧 JSON 输出示例 (完整有效文件):"
echo "----------------------------------------"
./arxml-validator -file examples/complete_valid_example.arxml -json | head -20
echo "..."
echo

# 详细错误分析
echo "🔍 详细错误分析 (常见错误文件):"
echo "----------------------------------------"
if [ -f "examples/common_errors_example.arxml" ]; then
    ./arxml-validator -file examples/common_errors_example.arxml 2>&1 | grep -A 20 "=== ARXML 验证结果 ==="
fi

echo
echo "🎉 测试完成!"
echo "所有示例文件已测试完成。"
echo "请查看上述结果以了解每个文件的验证情况。"