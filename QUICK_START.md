# 快速开始 - 使用 GitHub Actions 构建 APK

## 🚀 三步完成构建

### 第 1 步：提交并推送代码

运行自动化脚本：

```bash
./commit_and_push.sh
```

或者手动执行：

```bash
git add .
git commit -m "Add GitHub Actions build configuration"
git push origin master
```

### 第 2 步：查看构建进度

1. 打开浏览器访问：https://github.com/endvin/rustdesk/actions
2. 你会看到一个新的工作流运行开始
3. 点击进入查看实时构建日志

### 第 3 步：下载 APK

构建完成后（约 20-30 分钟）：

1. 在工作流运行页面向下滚动
2. 找到 "Artifacts" 部分
3. 点击 "android-apk" 下载
4. 解压 ZIP 文件获取 APK

## 📱 安装 APK

下载后，你会得到以下文件：

- `app-arm64-v8a-release.apk` - 适用于大多数现代 Android 设备（推荐）
- `app-armeabi-v7a-release.apk` - 适用于较旧的 32 位设备
- `app-release.apk` - 通用版本（体积较大）

### 通过 ADB 安装：

```bash
adb install app-arm64-v8a-release.apk
```

### 直接在手机上安装：

1. 将 APK 文件传输到手机
2. 在手机上找到文件并点击安装
3. 如果提示"未知来源"，需要在设置中允许安装

## 🔧 手动触发构建

如果推送后没有自动开始构建，可以手动触发：

1. 访问：https://github.com/endvin/rustdesk/actions
2. 点击左侧的 "Build Android APK"
3. 点击右侧的 "Run workflow" 按钮
4. 选择 "master" 分支
5. 点击绿色的 "Run workflow" 按钮

## ⏱️ 构建时间

- **首次构建**：30-40 分钟（需要下载所有依赖）
- **后续构建**：15-20 分钟（使用缓存）

## 📊 查看构建状态

构建过程中可以实时查看：

- ✅ 绿色勾号 = 构建成功
- ❌ 红色叉号 = 构建失败
- 🟡 黄色圆圈 = 正在构建

## 🐛 故障排除

### 构建失败？

1. 点击失败的工作流运行
2. 查看红色的步骤
3. 展开查看详细错误日志
4. 常见问题：
   - 网络超时：重新运行工作流
   - 依赖下载失败：GitHub Actions 会自动重试
   - 编译错误：检查代码更改

### 无法下载 Artifacts？

- Artifacts 保留 30 天
- 需要登录 GitHub 账户
- 确保构建已完成

## 💡 提示

1. **保存 APK**：下载后立即保存，30 天后会自动删除
2. **版本管理**：每次推送都会触发新构建，建议使用 Git tags 标记版本
3. **免费额度**：GitHub 免费账户每月 2000 分钟，足够多次构建

## 📚 更多信息

详细说明请查看：[BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

## ✨ 完成！

现在你可以：
1. 运行 `./commit_and_push.sh` 开始构建
2. 喝杯咖啡等待 20-30 分钟
3. 下载并安装你的自定义 RustDesk APK！
