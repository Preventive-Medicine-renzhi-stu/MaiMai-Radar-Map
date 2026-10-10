@echo off
chcp 65001 >nul
rem 中文文件名的入口，方便在资源管理器里一眼认出来；实际逻辑复用 start.bat。
call "%~dp0start.bat" %*
