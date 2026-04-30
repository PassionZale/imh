#!/bin/bash
set -e  # 任何命令失败就立即停止，避免错误继续执行

# 切换到项目根目录（无论从哪里运行这个脚本都能正确找到项目文件）
cd "$(dirname "$0")/.."

# 显示用法说明
usage() {
  echo "Usage: $0 <bump-type>"
  echo ""
  echo "Bump types:"
  echo "  major     1.0.0+1 -> 2.0.0+2  （大版本升级）"
  echo "  minor     1.0.0+1 -> 1.1.0+2  （功能更新）"
  echo "  patch     1.0.0+1 -> 1.0.1+2  （小修复）"
  echo "  build     1.0.0+1 -> 1.0.0+2  （仅构建号+1）"
  echo "  release   不升版本，直接打包"
  echo ""
  echo "Examples:"
  echo "  $0 patch"
  echo "  $0 release"
  exit 1
}

# 必须传一个参数，否则显示用法
if [ $# -ne 1 ]; then
  usage
fi

BUMP_TYPE=$1  # 获取传入的参数（patch/minor/major/build/release）

# 如果不是 "release"，先用 cider 升版本号
if [ "$BUMP_TYPE" != "release" ]; then
  echo "Bumping $BUMP_TYPE version..."
  cider bump "$BUMP_TYPE"        # 执行版本升级，会自动修改 pubspec.yaml
  NEW_VERSION=$(cider describe)  # 读取升级后的版本号
  echo "Version: $NEW_VERSION"
fi

# 读取当前版本号，用于后续显示和 APK 文件名
CURRENT_VERSION=$(cider describe)
echo ""
echo "Building release APK (v$currentVersion)..."

# 执行 Flutter release 打包
flutter build apk --release

# 拼接 APK 文件路径（archivesBaseName 已在 build.gradle.kts 中配置为 imh-v版本号）
APK_NAME="imh-v${CURRENT_VERSION%%+*}"  # 去掉 +后面的构建号，如 1.0.1+2 -> 1.0.1
APK_PATH="build/app/outputs/flutter-apk/$APK_NAME-release.apk"

# 检查 APK 是否生成成功，显示文件路径和大小
echo ""
if [ -f "$APK_PATH" ]; then
  echo "Build successful!"
  echo "APK: $APK_PATH"
  echo "Size: $(du -h "$APK_PATH" | cut -f1)"
else
  # 如果预期路径没找到，尝试在输出目录里搜索
  ACTUAL_APK=$(find build/app/outputs/flutter-apk -name "*release.apk" 2>/dev/null | head -1)
  if [ -n "$ACTUAL_APK" ]; then
    echo "Build successful!"
    echo "APK: $ACTUAL_APK"
    echo "Size: $(du -h "$ACTUAL_APK" | cut -f1)"
  else
    echo "Build completed. Check build/app/outputs/ for APK."
  fi
fi
