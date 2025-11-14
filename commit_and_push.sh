#!/bin/bash

set -e

echo "========================================="
echo "准备提交并推送到 GitHub"
echo "========================================="

# 检查是否有更改
if [[ -z $(git status -s) ]]; then
    echo "没有需要提交的更改"
    exit 0
fi

echo ""
echo "当前更改的文件："
git status --short

echo ""
echo "========================================="
echo "添加文件到 Git"
echo "========================================="

# 添加新的 workflow 文件
git add .github/workflows/build-android-apk.yml
git add BUILD_INSTRUCTIONS.md
git add build_apk.sh

# 添加已修改的文件
git add flutter/android/app/build.gradle
git add flutter/android/settings.gradle
git add flutter/lib/common.dart

# 添加生成的桥接代码
git add src/bridge_generated.rs
git add flutter/lib/generated_bridge.dart

# 添加 key.properties（如果存在）
git add flutter/android/key.properties 2>/dev/null || true

echo ""
echo "========================================="
echo "创建提交"
echo "========================================="

git commit -m "Add GitHub Actions workflow for Android APK build

- Add automated build workflow for Android
- Configure Flutter 3.24.5 and Rust 1.75
- Support arm64-v8a and armeabi-v7a architectures
- Add build instructions documentation
- Fix Gradle configuration for Flutter compatibility
"

echo ""
echo "========================================="
echo "推送到 GitHub"
echo "========================================="

echo ""
echo "即将推送到: $(git remote get-url origin)"
echo "分支: $(git branch --show-current)"
echo ""
read -p "确认推送？(y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin master
    
    echo ""
    echo "========================================="
    echo "✓ 推送成功！"
    echo "========================================="
    echo ""
    echo "下一步："
    echo "1. 访问 https://github.com/endvin/rustdesk/actions"
    echo "2. 查看 'Build Android APK' 工作流"
    echo "3. 等待构建完成（约 20-30 分钟）"
    echo "4. 下载构建好的 APK"
    echo ""
    echo "如果需要手动触发构建："
    echo "1. 点击 'Build Android APK' 工作流"
    echo "2. 点击 'Run workflow' 按钮"
    echo "3. 选择 'master' 分支"
    echo "4. 点击绿色的 'Run workflow' 按钮"
    echo ""
else
    echo ""
    echo "取消推送"
    exit 1
fi
