#!/bin/bash

echo "=== 🚀 РАЗВЕРТЫВАНИЕ GRANIVPN В DIGITALOCEAN ==="
echo ""

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker сначала."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен. Установите Docker Compose сначала."
    exit 1
fi

echo "✅ Docker и Docker Compose найдены"
echo ""

# Создание необходимых директорий
echo "📁 Создаю необходимые директории..."
mkdir -p backend/logs
mkdir -p wireguard-configs
mkdir -p nginx/ssl
mkdir -p nginx/sites-enabled
echo "✅ Директории созданы"
echo ""

# Копирование переменных окружения
if [ -f "env.production" ]; then
    echo "📋 Копирую переменные окружения..."
    cp env.production .env
    echo "✅ Переменные окружения скопированы"
else
    echo "⚠️  Файл env.production не найден. Создаю базовый .env..."
    cat > .env << EOF
DB_PASSWORD=granivpn_secure_password_2024
SECRET_KEY=granivpn_super_secret_key_change_this_in_production_2024
ENVIRONMENT=production
EOF
    echo "✅ Базовый .env создан"
fi
echo ""

# Остановка существующих контейнеров
echo "🛑 Останавливаю существующие контейнеры..."
docker-compose -f docker-compose.production.yml down
echo "✅ Контейнеры остановлены"
echo ""

# Сборка и запуск
echo "🔨 Собираю и запускаю контейнеры..."
docker-compose -f docker-compose.production.yml up --build -d
echo "✅ Контейнеры запущены"
echo ""

# Ожидание запуска
echo "⏳ Ожидаю запуска сервисов..."
sleep 30

# Проверка статуса
echo "📊 Проверяю статус сервисов..."
echo ""

# Backend
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Backend API работает на http://localhost:8000"
else
    echo "❌ Backend API не отвечает"
fi

# Admin Panel
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Admin Panel работает на http://localhost:3000"
else
    echo "❌ Admin Panel не отвечает"
fi

# Mobile App
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Mobile App работает на http://localhost:8080"
else
    echo "❌ Mobile App не отвечает"
fi

# Database
if docker exec granivpn-postgres pg_isready -U granivpn > /dev/null 2>&1; then
    echo "✅ PostgreSQL работает"
else
    echo "❌ PostgreSQL не отвечает"
fi

# Redis
if docker exec granivpn-redis redis-cli ping > /dev/null 2>&1; then
    echo "✅ Redis работает"
else
    echo "❌ Redis не отвечает"
fi

echo ""
echo "=== 🔗 ДОСТУПНЫЕ ССЫЛКИ ==="
echo "   🔧 API: http://localhost:8000"
echo "   📚 API Docs: http://localhost:8000/docs"
echo "   🖥️ Admin Panel: http://localhost:3000"
echo "   📱 Mobile App: http://localhost:8080"
echo ""

echo "=== 📋 КОМАНДЫ УПРАВЛЕНИЯ ==="
echo "   Просмотр логов: docker-compose -f docker-compose.production.yml logs -f"
echo "   Остановка: docker-compose -f docker-compose.production.yml down"
echo "   Перезапуск: docker-compose -f docker-compose.production.yml restart"
echo ""

echo "=== ✅ РАЗВЕРТЫВАНИЕ ЗАВЕРШЕНО ==="
echo "Для продакшн развертывания в DigitalOcean:"
echo "1. Скопируйте этот проект на сервер"
echo "2. Настройте домен и SSL сертификаты"
echo "3. Обновите переменные окружения"
echo "4. Запустите этот скрипт"
