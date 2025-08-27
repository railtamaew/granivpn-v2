#!/bin/bash

echo "🔧 Создание администратора GraniVPN"
echo "=================================="

# Проверяем, запущен ли Docker
if ! docker-compose ps | grep -q "granivpn_api"; then
    echo "❌ API сервис не запущен. Сначала запустите проект:"
    echo "   ./start.sh"
    exit 1
fi

# Запрашиваем данные
read -p "Введите email администратора: " email
if [ -z "$email" ]; then
    echo "❌ Email не может быть пустым!"
    exit 1
fi

read -s -p "Введите пароль: " password
echo
if [ -z "$password" ]; then
    echo "❌ Пароль не может быть пустым!"
    exit 1
fi

if [ ${#password} -lt 6 ]; then
    echo "❌ Пароль должен содержать минимум 6 символов!"
    exit 1
fi

read -p "Введите имя (необязательно): " first_name
read -p "Введите фамилию (необязательно): " last_name

echo
echo "📝 Создание администратора..."

# Запускаем скрипт создания админа в контейнере
docker-compose exec api python create_admin.py << EOF
$email
$password
$first_name
$last_name
EOF

echo
echo "✅ Готово! Теперь вы можете войти в админ панель:"
echo "   http://localhost:3000"



