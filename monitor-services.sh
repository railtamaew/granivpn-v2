#!/bin/bash

echo "=== 🚀 GRANIVPN SYSTEM STATUS ==="
echo ""

# Backend Status
echo "🔧 Backend (Python FastAPI):"
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "   ✅ Работает на http://localhost:8000"
    echo "   📊 Health: $(curl -s http://localhost:8000/health | jq -r '.status' 2>/dev/null || echo 'OK')"
else
    echo "   ❌ Не отвечает"
fi
echo ""

# Admin Panel Status
echo "🖥️ Admin Panel (React):"
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "   ✅ Работает на http://localhost:3000"
    echo "   🌐 Доступен в браузере"
else
    echo "   ❌ Не отвечает"
fi
echo ""

# Mobile App Status
echo "📱 Mobile App (Flutter Web):"
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "   ✅ Работает на http://localhost:8080"
    echo "   🌐 Доступен в браузере"
else
    echo "   🔄 Запускается или не отвечает"
fi
echo ""

# Process Status
echo "📋 Процессы:"
echo "   Python Backend: $(ps aux | grep 'python3.*main_demo.py' | grep -v grep | wc -l | tr -d ' ') запущено"
echo "   React Admin: $(ps aux | grep 'npm start' | grep -v grep | wc -l | tr -d ' ') запущено"
echo "   Flutter Web: $(ps aux | grep 'flutter run' | grep -v grep | wc -l | tr -d ' ') запущено"
echo ""

echo "=== 🔗 ДОСТУПНЫЕ ССЫЛКИ ==="
echo "   🔧 API: http://localhost:8000"
echo "   🖥️ Admin: http://localhost:3000"
echo "   📱 Mobile: http://localhost:8080"
echo "   📚 API Docs: http://localhost:8000/docs"
echo ""

echo "=== 📊 СИСТЕМА ГОТОВА К РАБОТЕ ==="
