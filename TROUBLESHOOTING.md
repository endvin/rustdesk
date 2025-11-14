# GitHub Actions 构建故障排查

## 如何查看构建日志

1. 访问 https://github.com/endvin/rustdesk/actions
2. 点击失败的工作流运行
3. 点击 "build-android-arm64-only" 作业
4. 展开红色的步骤查看详细错误

## 常见错误及解决方案

### 1. vcpkg 依赖安装失败

**错误信息：**
```
Error: Could not find package libvpx
```

**解决方案：**
- 这通常是网络问题，点击 "Re-run failed jobs" 重试
- vcpkg 会自动重试下载

### 2. Rust 编译错误

**错误信息：**
```
error: could not compile `rustdesk`
```

**可能原因：**
- 代码语法错误
- 依赖版本不兼容

**解决方案：**
- 检查最近的代码更改
- 确保 `src/bridge_generated.rs` 已提交
- 尝试在本地编译测试

### 3. Flutter 构建错误

**错误信息：**
```
Gradle task assembleRelease failed
```

**解决方案：**
- 检查 `flutter/android/app/build.gradle` 配置
- 确保 `flutter/lib/generated_bridge.dart` 已提交
- 查看完整的 Gradle 日志

### 4. 磁盘空间不足

**错误信息：**
```
No space left on device
```

**解决方案：**
- 工作流已包含清理步骤
- 如果仍然失败，可能需要减少构建目标

### 5. NDK 版本问题

**错误信息：**
```
NDK not found
```

**解决方案：**
- 检查 NDK_VERSION 环境变量
- 确保使用支持的 NDK 版本（r26b 或 r27c）

## 调试技巧

### 1. 启用详细日志

在工作流文件中添加：

```yaml
- name: Build with verbose logging
  run: |
    cargo build --verbose
    flutter build apk --verbose
```

### 2. 检查特定步骤

在失败的步骤前添加检查：

```yaml
- name: Check environment
  run: |
    echo "VCPKG_ROOT: $VCPKG_ROOT"
    echo "ANDROID_NDK_HOME: $ANDROID_NDK_HOME"
    ls -la flutter/android/app/src/main/jniLibs/
```

### 3. 使用 tmate 调试

添加此步骤可以通过 SSH 连接到 GitHub Actions 运行器：

```yaml
- name: Setup tmate session
  if: failure()
  uses: mxschmitt/action-tmate@v3
```

## 快速修复清单

- [ ] 检查所有必要文件是否已提交
- [ ] 确认 Git 分支是 master 或 main
- [ ] 验证 `src/bridge_generated.rs` 存在
- [ ] 验证 `flutter/lib/generated_bridge.dart` 存在
- [ ] 检查最近的代码更改是否引入错误
- [ ] 尝试重新运行失败的作业
- [ ] 查看完整的构建日志

## 如果一切都失败了

### 方案 A：使用原始项目的 CI

1. 检查原始项目的最新 CI 配置
2. 复制他们的工作流文件
3. 根据需要调整

### 方案 B：本地构建

如果 GitHub Actions 持续失败，可以：

1. 使用 Docker 在本地构建
2. 使用 Linux 虚拟机
3. 使用云服务器（如 AWS、GCP）

### 方案 C：使用预构建的 APK

1. 从官方 Releases 下载
2. 使用 F-Droid 版本
3. 等待官方更新

## 获取帮助

如果以上方法都不起作用：

1. **查看项目 Issues**：https://github.com/rustdesk/rustdesk/issues
2. **查看 Discussions**：https://github.com/rustdesk/rustdesk/discussions
3. **Discord 社区**：https://discord.gg/nDceKgxnkV

## 报告问题时请提供

1. 完整的错误日志
2. 工作流文件内容
3. 最近的代码更改
4. 使用的 Flutter/Rust 版本
5. GitHub Actions 运行链接

## 成功构建的标志

✅ 所有步骤都是绿色
✅ 可以看到 "Artifacts" 部分
✅ 可以下载 APK 文件
✅ APK 文件大小合理（通常 20-40 MB）

## 验证 APK

下载后验证 APK：

```bash
# 检查 APK 信息
aapt dump badging rustdesk-arm64-v8a.apk

# 检查签名
jarsigner -verify -verbose rustdesk-arm64-v8a.apk

# 安装测试
adb install rustdesk-arm64-v8a.apk
```
