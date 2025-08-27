#!/bin/bash

echo "=== 🚀 ЗАПУСК ВСЕХ СЕРВИСОВ GRANIVPN ==="
echo ""

# Остановка существующих процессов
echo "🛑 Останавливаю существующие процессы..."
pkill -f "python3.*main_demo.py" 2>/dev/null
pkill -f "npm start" 2>/dev/null
pkill -f "flutter run" 2>/dev/null
sleep 3
echo "✅ Процессы остановлены"
echo ""

# Запуск Backend
echo "🔧 Запускаю Backend (Python FastAPI)..."
cd backend
python3 main_demo.py > ../backend.log 2>&1 &
BACKEND_PID=$!
echo "   PID: $BACKEND_PID"
cd ..
sleep 5

# Проверка Backend
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Backend запущен на http://localhost:8000"
else
    echo "❌ Backend не запустился"
    exit 1
fi
echo ""

# Запуск Admin Panel
echo "🖥️ Запускаю Admin Panel (React)..."
cd admin-panel
npm start > ../admin-panel.log 2>&1 &
ADMIN_PID=$!
echo "   PID: $ADMIN_PID"
cd ..
sleep 10

# Проверка Admin Panel
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Admin Panel запущен на http://localhost:3000"
else
    echo "❌ Admin Panel не запустился"
fi
echo ""

# Запуск Mobile App
echo "📱 Запускаю Mobile App (Flutter Web)..."
cd mobile-app
flutter run -d chrome --web-port 8080 > ../mobile-app.log 2>&1 &
FLUTTER_PID=$!
echo "   PID: $FLUTTER_PID"
cd ..
sleep 15

# Проверка Mobile App
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Mobile App запущен на http://localhost:8080"
else
    echo "🔄 Mobile App запускается..."
fi
echo ""

# Сохранение PID процессов
echo "$BACKEND_PID" > backend.pid
echo "$ADMIN_PID" > admin-panel.pid
echo "$FLUTTER_PID" > mobile-app.pid

echo "=== 📊 СТАТУС ЗАПУСКА ==="
echo "   🔧 Backend PID: $BACKEND_PID"
echo "   🖥️ Admin Panel PID: $ADMIN_PID"
echo "   📱 Mobile App PID: $FLUTTER_PID"
echo ""

echo "=== 🔗 ДОСТУПНЫЕ ССЫЛКИ ==="
echo "   🔧 API: http://localhost:8000"
echo "   🖥️ Admin: http://localhost:3000"
echo "   📱 Mobile: http://localhost:8080"
echo "   📚 API Docs: http://localhost:8000/docs"
echo ""

echo "=== ✅ ВСЕ СЕРВИСЫ ЗАПУЩЕНЫ ==="
echo "Для мониторинга запустите: ./monitor-services.sh"
echo "Для остановки запустите: ./stop-all-services.sh"
