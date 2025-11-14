#!/bin/bash

echo "========================================="
echo "推送前检查"
echo "========================================="
echo ""

errors=0

# 检查必要的生成文件
echo "检查生成的文件..."
if [ ! -f "src/bridge_generated.rs" ]; then
    echo "❌ 缺少 src/bridge_generated.rs"
    echo "   运行: flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart"
    errors=$((errors + 1))
else
    echo "✓ src/bridge_generated.rs"
fi

if [ ! -f "flutter/lib/generated_bridge.dart" ]; then
    echo "❌ 缺少 flutter/lib/generated_bridge.dart"
    errors=$((errors + 1))
else
    echo "✓ flutter/lib/generated_bridge.dart"
fi

echo ""
echo "检查工作流文件..."
if [ ! -f ".github/workflows/build-android-apk.yml" ]; then
    echo "❌ 缺少 .github/workflows/build-android-apk.yml"
    errors=$((errors + 1))
else
    echo "✓ .github/workflows/build-android-apk.yml"
fi

echo ""
echo "检查 Rust 库（可选）..."
if [ -f "flutter/android/app/src/main/jniLibs/arm64-v8a/librustdesk.so" ]; then
    size=$(ls -lh flutter/android/app/src/main/jniLibs/arm64-v8a/librustdesk.so | awk '{print $5}')
    echo "✓ 预编译的 Rust 库存在 ($size)"
    echo "  这将加速 GitHub Actions 构建"
else
    echo "ℹ 没有预编译的 Rust 库"
    echo "  GitHub Actions 将从源码编译（需要更长时间）"
fi

echo ""
echo "检查 Git 状态..."
if [ -z "$(git status --porcelain)" ]; then
    echo "✓ 没有未提交的更改"
else
    echo "⚠ 有未提交的更改："
    git status --short | head -10
fi

echo ""
echo "检查远程仓库..."
remote_url=$(git remote get-url origin 2>/dev/null)
if [ -z "$remote_url" ]; then
    echo "❌ 没有配置远程仓库"
    errors=$((errors + 1))
else
    echo "✓ 远程仓库: $remote_url"
fi

echo ""
echo "========================================="

if [ $errors -eq 0 ]; then
    echo "✅ 所有检查通过！"
    echo ""
    echo "可以安全推送："
    echo "  git add ."
    echo "  git commit -m 'Ready for GitHub Actions build'"
    echo "  git push origin master"
    echo ""
    echo "或运行："
    echo "  ./commit_and_push.sh"
else
    echo "❌ 发现 $errors 个错误"
    echo ""
    echo "请修复上述问题后再推送"
fi

echo "========================================="

exit $errors
