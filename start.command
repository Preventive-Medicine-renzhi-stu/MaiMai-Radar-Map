#!/usr/bin/env bash
# macOS：双击本文件即会打开终端并启动服务（`.command` 后缀让 Finder 可执行）。
exec bash "$(dirname "$0")/start.sh" "$@"
