#!/bin/bash

echo "🚀 Запуск GraniVPN проекта..."

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Установите Docker и попробуйте снова."
    exit 1
fi

# Проверяем наличие Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен. Установите Docker Compose и попробуйте снова."
    exit 1
fi

# Создаем .env файл если его нет
if [ ! -f .env ]; then
    echo "📝 Создание .env файла..."
    cat > .env << EOF
# Database
POSTGRES_PASSWORD=granivpn_secure_password_2024

# Security
SECRET_KEY=your-super-secret-key-change-this-in-production

# Domain
DOMAIN=granivpn.com
API_URL=http://localhost:8000

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# WireGuard
WIREGUARD_SERVER_IP=94.131.107.227
WIREGUARD_PORT=51820
EOF
    echo "✅ .env файл создан"
fi

# Останавливаем существующие контейнеры
echo "🛑 Остановка существующих контейнеров..."
docker-compose down

# Собираем и запускаем контейнеры
echo "🔨 Сборка и запуск контейнеров..."
docker-compose up -d --build

# Ждем немного для запуска сервисов
echo "⏳ Ожидание запуска сервисов..."
sleep 10

# Проверяем статус
echo "📊 Статус сервисов:"
docker-compose ps

echo ""
echo "🎉 Проект запущен!"
echo ""
echo "📱 Admin Panel: http://localhost:3000"
echo "🔧 API Documentation: http://localhost:8000/docs"
echo "🏥 Health Check: http://localhost:8000/health"
echo ""
echo "📋 Полезные команды:"
echo "  docker-compose logs -f    # Просмотр логов"
echo "  docker-compose down       # Остановка"
echo "  docker-compose restart    # Перезапуск"
echo ""




