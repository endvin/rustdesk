#!/bin/bash

echo "========================================="
echo "检查 GitHub Actions 构建准备情况"
echo "========================================="
echo ""

# 检查必要文件
files_to_check=(
    ".github/workflows/build-android-apk.yml"
    "BUILD_INSTRUCTIONS.md"
    "src/bridge_generated.rs"
    "flutter/lib/generated_bridge.dart"
    "Cargo.toml"
    "flutter/pubspec.yaml"
)

all_good=true

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file (缺失)"
        all_good=false
    fi
done

echo ""
echo "========================================="
echo "检查 Git 配置"
echo "========================================="
echo ""

echo "Git 用户名: $(git config user.name)"
echo "Git 邮箱: $(git config user.email)"
echo "当前分支: $(git branch --show-current)"
echo "远程仓库: $(git remote get-url origin)"

echo ""
echo "========================================="
echo "待提交的更改"
echo "========================================="
echo ""

git status --short

echo ""
echo "========================================="

if [ "$all_good" = true ]; then
    echo "✓ 所有检查通过！"
    echo ""
    echo "准备就绪，可以运行："
    echo "  ./commit_and_push.sh"
    echo ""
    echo "或者手动执行："
    echo "  git add ."
    echo "  git commit -m 'Add GitHub Actions build'"
    echo "  git push origin master"
else
    echo "✗ 有文件缺失，请检查"
fi

echo "========================================="
