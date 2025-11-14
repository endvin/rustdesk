#!/usr/bin/env bash

set -e

echo "========================================="
echo "RustDesk Android APK 构建脚本"
echo "========================================="

# 设置环境变量
export PATH="$HOME/.cargo/bin:$HOME/flutter/bin:$PATH"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_NDK_HOME="$ANDROID_SDK_ROOT/ndk/25.2.9519653"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"

echo "环境变量设置："
echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "ANDROID_NDK_HOME: $ANDROID_NDK_HOME"
echo ""

# 检查必要的工具
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "错误: 未找到 $1"
        return 1
    fi
    return 0
}

echo "检查必要工具..."
if ! check_tool cargo; then
    echo "请运行: source $HOME/.cargo/env"
    exit 1
fi

if ! check_tool flutter; then
    echo "Flutter 路径: $HOME/flutter/bin/flutter"
    exit 1
fi

if ! check_tool rustup; then
    exit 1
fi

echo "✓ 所有工具检查通过"
echo ""

# 安装 cargo-ndk（如果未安装）
if ! cargo ndk --version &> /dev/null; then
    echo "安装 cargo-ndk..."
    cargo install cargo-ndk
fi

# 添加 Android 目标
echo "添加 Android 编译目标..."
rustup target add aarch64-linux-android armv7-linux-androideabi

# 进入 flutter 目录
cd flutter

# 编译 Rust 库 (arm64)
echo "========================================="
echo "编译 Rust 库 (arm64-v8a)..."
echo "========================================="
cd ..
cargo ndk --platform 21 --target aarch64-linux-android build --release --features flutter,hwcodec

# 编译 Rust 库 (armv7)
echo "========================================="
echo "编译 Rust 库 (armeabi-v7a)..."
echo "========================================="
cargo ndk --platform 21 --target armv7-linux-androideabi build --release --features flutter,hwcodec

# 复制库文件到 Android 项目
echo "复制库文件..."
mkdir -p flutter/android/app/src/main/jniLibs/arm64-v8a
mkdir -p flutter/android/app/src/main/jniLibs/armeabi-v7a

cp target/aarch64-linux-android/release/liblibrustdesk.so flutter/android/app/src/main/jniLibs/arm64-v8a/librustdesk.so
cp target/armv7-linux-androideabi/release/liblibrustdesk.so flutter/android/app/src/main/jniLibs/armeabi-v7a/librustdesk.so

# 进入 flutter 目录
cd flutter

# 获取 Flutter 依赖
echo "获取 Flutter 依赖..."
flutter pub get

# 构建 APK
echo "========================================="
echo "构建 APK..."
echo "========================================="
flutter build apk --release --split-per-abi --target-platform android-arm64,android-arm

echo "========================================="
echo "构建完成！"
echo "========================================="
echo "APK 文件位置："
ls -lh build/app/outputs/flutter-apk/*.apk

echo ""
echo "可以使用以下命令安装到设备："
echo "adb install build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk"
echo "或"
echo "adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
