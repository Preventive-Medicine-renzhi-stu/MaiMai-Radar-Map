#!/usr/bin/env bash
# ===========================================================================
#  麦当劳雷达地图 · 一键启动（macOS / Linux，终端里双击 start.command 亦可）
#
#  做三件事：
#    1. 找到（或创建）Python 虚拟环境
#    2. 缺依赖就装上
#    3. 起本地服务并自动打开浏览器
#
#  可传参给服务，例如：  bash start.sh --port 9000 --no-open
# ===========================================================================
set -uo pipefail

cd "$(dirname "$0")" || exit 1

VENV_PY=".venv/bin/python"
BOOT_PY=""

if [ -x "$VENV_PY" ]; then
  BOOT_PY="$VENV_PY"
elif command -v python3 >/dev/null 2>&1; then
  BOOT_PY="python3"
elif command -v python >/dev/null 2>&1; then
  BOOT_PY="python"
else
  cat <<'EOF'

  [x] 没有找到 Python。
      请先安装 Python 3.10 或更高版本：https://www.python.org/downloads/
      安装后重新双击本脚本即可。

EOF
  read -r -p "  按回车键关闭…" _
  exit 1
fi

if [ ! -x "$VENV_PY" ]; then
  echo "  [1/3] 首次运行：创建虚拟环境 .venv ..."
  if ! "$BOOT_PY" -m venv .venv; then
    echo "  [x] 创建虚拟环境失败，请确认 Python 安装完整（含 venv 模块）。"
    read -r -p "  按回车键关闭…" _
    exit 1
  fi
fi

if ! "$VENV_PY" -c "import mcp, dotenv" >/dev/null 2>&1; then
  echo "  [2/3] 安装依赖（mcp / python-dotenv）..."
  "$VENV_PY" -m pip install --upgrade pip >/dev/null 2>&1 || true
  if ! "$VENV_PY" -m pip install -r requirements.txt; then
    echo "  [x] 依赖安装失败，请检查网络后重试。"
    read -r -p "  按回车键关闭…" _
    exit 1
  fi
fi

echo "  [3/3] 启动本地服务，浏览器稍后自动打开 ..."
"$VENV_PY" -m src.serve "$@"
status=$?

if [ $status -ne 0 ]; then
  echo "  [x] 服务异常退出（退出码 $status），请查看上方信息。"
  read -r -p "  按回车键关闭…" _
fi
exit $status
