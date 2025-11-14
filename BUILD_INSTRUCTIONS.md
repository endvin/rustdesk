# RustDesk Android APK 构建指南

## 使用 GitHub Actions 自动构建

### 步骤 1: Fork 项目到你的 GitHub

1. 访问 https://github.com/rustdesk/rustdesk
2. 点击右上角的 "Fork" 按钮
3. 等待 Fork 完成

### 步骤 2: 推送你的本地更改到 Fork 的仓库

```bash
# 添加你的 Fork 仓库为远程仓库
git remote add myfork https://github.com/你的用户名/rustdesk.git

# 提交当前更改
git add .
git commit -m "Add custom build configuration"

# 推送到你的 Fork
git push myfork master
```

### 步骤 3: 触发 GitHub Actions 构建

有两种方式触发构建：

#### 方式 1: 自动触发（推荐）
推送代码后，GitHub Actions 会自动开始构建。

#### 方式 2: 手动触发
1. 访问你的 Fork 仓库页面
2. 点击 "Actions" 标签
3. 在左侧选择 "Build Android APK"
4. 点击右侧的 "Run workflow" 按钮
5. 选择分支（通常是 master 或 main）
6. 点击绿色的 "Run workflow" 按钮

### 步骤 4: 下载构建好的 APK

1. 等待构建完成（大约 20-30 分钟）
2. 在 Actions 页面，点击完成的工作流运行
3. 向下滚动到 "Artifacts" 部分
4. 点击 "android-apk" 下载 ZIP 文件
5. 解压 ZIP 文件，里面包含：
   - `app-arm64-v8a-release.apk` (适用于 64 位 ARM 设备)
   - `app-armeabi-v7a-release.apk` (适用于 32 位 ARM 设备)
   - `app-release.apk` (通用版本，包含所有架构)

### 步骤 5: 安装 APK

```bash
# 通过 ADB 安装
adb install app-arm64-v8a-release.apk

# 或者直接传输到手机上点击安装
```

## 本地构建（如果 GitHub Actions 不可用）

如果你想在本地构建，可以使用提供的脚本：

```bash
# 确保已安装所有依赖
./build_apk.sh
```

## 故障排除

### 构建失败
- 检查 Actions 日志中的错误信息
- 确保所有依赖都正确安装
- 可能需要调整 Flutter 或 Rust 版本

### 签名问题
- GitHub Actions 构建的 APK 使用 debug 签名
- 如果需要发布版本，需要配置签名密钥

### 网络问题
- GitHub Actions 在国外服务器运行，网络通常很快
- 如果下载依赖失败，Actions 会自动重试

## 注意事项

1. **首次构建时间较长**：第一次构建可能需要 30-40 分钟，因为需要下载所有依赖
2. **后续构建更快**：GitHub Actions 会缓存依赖，后续构建约 15-20 分钟
3. **Artifacts 保留期**：构建的 APK 会保留 30 天
4. **免费额度**：GitHub 免费账户每月有 2000 分钟的 Actions 时间

## 高级配置

### 添加签名密钥

如果你想构建发布版本的 APK，需要：

1. 生成签名密钥
2. 将密钥添加到 GitHub Secrets
3. 修改 workflow 文件以使用签名密钥

详细步骤请参考 GitHub Actions 文档。

### 自定义构建选项

你可以修改 `.github/workflows/build-android-apk.yml` 文件来：
- 更改 Flutter 版本
- 更改 Rust 版本
- 添加或移除功能特性
- 修改构建目标平台

## 相关链接

- [RustDesk 官方文档](https://rustdesk.com/docs/)
- [Flutter 文档](https://flutter.dev/docs)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
