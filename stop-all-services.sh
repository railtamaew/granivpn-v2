#!/bin/bash

echo "=== 🛑 ОСТАНОВКА ВСЕХ СЕРВИСОВ GRANIVPN ==="
echo ""

# Остановка по PID файлам
if [ -f "backend.pid" ]; then
    BACKEND_PID=$(cat backend.pid)
    echo "🔧 Останавливаю Backend (PID: $BACKEND_PID)..."
    kill $BACKEND_PID 2>/dev/null
    rm backend.pid
    echo "✅ Backend остановлен"
else
    echo "🔧 Backend PID файл не найден, останавливаю по имени процесса..."
    pkill -f "python3.*main_demo.py" 2>/dev/null
    echo "✅ Backend остановлен"
fi
echo ""

if [ -f "admin-panel.pid" ]; then
    ADMIN_PID=$(cat admin-panel.pid)
    echo "🖥️ Останавливаю Admin Panel (PID: $ADMIN_PID)..."
    kill $ADMIN_PID 2>/dev/null
    rm admin-panel.pid
    echo "✅ Admin Panel остановлен"
else
    echo "🖥️ Admin Panel PID файл не найден, останавливаю по имени процесса..."
    pkill -f "npm start" 2>/dev/null
    echo "✅ Admin Panel остановлен"
fi
echo ""

if [ -f "mobile-app.pid" ]; then
    FLUTTER_PID=$(cat mobile-app.pid)
    echo "📱 Останавливаю Mobile App (PID: $FLUTTER_PID)..."
    kill $FLUTTER_PID 2>/dev/null
    rm mobile-app.pid
    echo "✅ Mobile App остановлен"
else
    echo "📱 Mobile App PID файл не найден, останавливаю по имени процесса..."
    pkill -f "flutter run" 2>/dev/null
    echo "✅ Mobile App остановлен"
fi
echo ""

# Дополнительная очистка
echo "🧹 Очищаю оставшиеся процессы..."
pkill -f "python3.*main_demo.py" 2>/dev/null
pkill -f "npm start" 2>/dev/null
pkill -f "flutter run" 2>/dev/null
pkill -f "node.*react-scripts" 2>/dev/null

# Ожидание завершения
sleep 3

echo "=== 📊 СТАТУС ОСТАНОВКИ ==="
echo "   🔧 Backend: $(ps aux | grep 'python3.*main_demo.py' | grep -v grep | wc -l | tr -d ' ') процессов"
echo "   🖥️ Admin Panel: $(ps aux | grep 'npm start' | grep -v grep | wc -l | tr -d ' ') процессов"
echo "   📱 Mobile App: $(ps aux | grep 'flutter run' | grep -v grep | wc -l | tr -d ' ') процессов"
echo ""

echo "=== ✅ ВСЕ СЕРВИСЫ ОСТАНОВЛЕНЫ ==="
echo "Для запуска всех сервисов выполните: ./start-all-services.sh"
