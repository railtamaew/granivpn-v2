#!/bin/bash

echo "=== 🚀 АВТОМАТИЧЕСКАЯ НАСТРОЙКА GITHUB ACTIONS ==="
echo ""

# Проверяем наличие необходимых инструментов
check_requirements() {
    echo "🔍 Проверяю требования..."
    
    if ! command -v git &> /dev/null; then
        echo "❌ Git не установлен"
        exit 1
    fi
    
    if ! command -v gh &> /dev/null; then
        echo "⚠️  GitHub CLI не установлен. Устанавливаю..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install gh
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update && sudo apt install gh -y
        else
            echo "❌ Неподдерживаемая ОС. Установите GitHub CLI вручную"
            exit 1
        fi
    fi
    
    echo "✅ Все требования выполнены"
    echo ""
}

# Настройка GitHub CLI
setup_github_cli() {
    echo "🔐 Настраиваю GitHub CLI..."
    
    if ! gh auth status &> /dev/null; then
        echo "Войдите в GitHub..."
        gh auth login
    else
        echo "✅ GitHub CLI уже настроен"
    fi
    
    echo ""
}

# Создание SSH ключа
create_ssh_key() {
    echo "🔑 Создаю SSH ключ..."
    
    SSH_KEY_PATH="$HOME/.ssh/granivpn_key"
    
    if [ ! -f "$SSH_KEY_PATH" ]; then
        echo "Создаю новый SSH ключ для GraniVPN..."
        ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "granivpn@github.com"
        echo "✅ SSH ключ создан: $SSH_KEY_PATH"
    else
        echo "✅ SSH ключ уже существует: $SSH_KEY_PATH"
    fi
    
    # Показываем публичный ключ
    echo ""
    echo "📋 Публичный ключ (добавьте его на DigitalOcean сервер):"
    echo "=========================================="
    cat "${SSH_KEY_PATH}.pub"
    echo "=========================================="
    echo ""
    
    # Показываем приватный ключ
    echo "🔐 Приватный ключ (добавьте в GitHub Secrets как DROPLET_SSH_KEY):"
    echo "=========================================="
    cat "$SSH_KEY_PATH"
    echo "=========================================="
    echo ""
}

# Создание DigitalOcean Droplet
create_droplet() {
    echo "🌊 Создание DigitalOcean Droplet..."
    
    if ! command -v doctl &> /dev/null; then
        echo "⚠️  DigitalOcean CLI не установлен. Устанавливаю..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install doctl
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            snap install doctl
        else
            echo "❌ Установите DigitalOcean CLI вручную: https://docs.digitalocean.com/reference/doctl/how-to/install/"
            exit 1
        fi
    fi
    
    echo "🔐 Настройте DigitalOcean API токен:"
    echo "1. Перейдите в https://cloud.digitalocean.com/account/api/tokens"
    echo "2. Создайте новый токен с правами Write"
    echo "3. Скопируйте токен"
    echo ""
    
    read -p "Введите ваш DigitalOcean API токен: " DO_TOKEN
    
    if [ -z "$DO_TOKEN" ]; then
        echo "❌ Токен не введен"
        return 1
    fi
    
    # Настраиваем doctl
    doctl auth init --access-token "$DO_TOKEN"
    
    echo ""
    echo "🌍 Выберите регион для сервера:"
    doctl compute region list
    
    read -p "Введите slug региона (например, nyc1): " REGION
    
    echo ""
    echo "💾 Выберите размер Droplet:"
    doctl compute size list
    
    read -p "Введите slug размера (например, s-1vcpu-1gb): " SIZE
    
    echo ""
    read -p "Введите имя для Droplet (например, granivpn-server): " DROPLET_NAME
    
    if [ -z "$DROPLET_NAME" ]; then
        DROPLET_NAME="granivpn-server"
    fi
    
    # Создаем Droplet
    echo "🚀 Создаю Droplet..."
    DROPLET_ID=$(doctl compute droplet create "$DROPLET_NAME" \
        --size "$SIZE" \
        --image ubuntu-22-04-x64 \
        --region "$REGION" \
        --ssh-keys "$(doctl compute ssh-key list --format ID,Name --no-header | grep "$(whoami)" | awk '{print $1}' | head -1)" \
        --format ID,Name,PublicIPv4,Region,Status \
        --no-header | head -1)
    
    if [ $? -eq 0 ]; then
        echo "✅ Droplet создан успешно!"
        echo "$DROPLET_ID"
        
        # Ждем запуска
        echo "⏳ Ждем запуска Droplet..."
        sleep 30
        
        # Получаем IP адрес
        DROPLET_IP=$(doctl compute droplet get "$DROPLET_NAME" --format PublicIPv4 --no-header)
        echo "🌐 IP адрес сервера: $DROPLET_IP"
        
        # Сохраняем информацию
        echo "DROPLET_IP=$DROPLET_IP" > .env.droplet
        echo "DROPLET_NAME=$DROPLET_NAME" >> .env.droplet
        
    else
        echo "❌ Ошибка создания Droplet"
        return 1
    fi
    
    echo ""
}

# Настройка GitHub Secrets
setup_github_secrets() {
    echo "🔐 Настройка GitHub Secrets..."
    
    if [ -f ".env.droplet" ]; then
        source .env.droplet
    else
        read -p "Введите IP адрес вашего DigitalOcean сервера: " DROPLET_IP
    fi
    
    if [ -z "$DROPLET_IP" ]; then
        echo "❌ IP адрес не указан"
        return 1
    fi
    
    SSH_KEY_PATH="$HOME/.ssh/granivpn_key"
    
    if [ ! -f "$SSH_KEY_PATH" ]; then
        echo "❌ SSH ключ не найден"
        return 1
    fi
    
    # Получаем имя репозитория
    REPO_NAME=$(git remote get-url origin | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')
    
    echo "📁 Репозиторий: $REPO_NAME"
    echo ""
    
    # Добавляем секреты
    echo "➕ Добавляю секрет DROPLET_HOST..."
    echo "$DROPLET_IP" | gh secret set DROPLET_HOST --repo "$REPO_NAME"
    
    echo "➕ Добавляю секрет DROPLET_USER..."
    echo "root" | gh secret set DROPLET_USER --repo "$REPO_NAME"
    
    echo "➕ Добавляю секрет DROPLET_SSH_KEY..."
    cat "$SSH_KEY_PATH" | gh secret set DROPLET_SSH_KEY --repo "$REPO_NAME"
    
    echo "➕ Добавляю секрет DROPLET_PORT..."
    echo "22" | gh secret set DROPLET_PORT --repo "$REPO_NAME"
    
    echo ""
    echo "✅ Все секреты добавлены в GitHub!"
    echo ""
}

# Настройка сервера
setup_server() {
    echo "🔧 Настройка сервера..."
    
    if [ -f ".env.droplet" ]; then
        source .env.droplet
    else
        read -p "Введите IP адрес вашего сервера: " DROPLET_IP
    fi
    
    if [ -z "$DROPLET_IP" ]; then
        echo "❌ IP адрес не указан"
        return 1
    fi
    
    SSH_KEY_PATH="$HOME/.ssh/granivpn_key"
    
    echo "📡 Подключаюсь к серверу..."
    
    # Ждем доступности сервера
    echo "⏳ Ждем доступности сервера..."
    while ! ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no root@"$DROPLET_IP" exit &> /dev/null; do
        echo "Сервер еще не доступен, ждем..."
        sleep 10
    done
    
    echo "✅ Сервер доступен!"
    
    # Устанавливаем Docker
    echo "🐳 Устанавливаю Docker..."
    ssh -i "$SSH_KEY_PATH" root@"$DROPLET_IP" << 'EOF'
        # Обновление системы
        apt update && apt upgrade -y
        
        # Установка Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        
        # Установка Docker Compose
        apt install docker-compose-plugin -y
        
        # Добавление пользователя в группу docker
        usermod -aG docker root
        
        # Включение автозапуска
        systemctl enable docker
        systemctl start docker
        
        echo "Docker установлен успешно!"
EOF
    
    # Копируем SSH ключ на сервер
    echo "🔑 Копирую SSH ключ на сервер..."
    ssh-copy-id -i "${SSH_KEY_PATH}.pub" root@"$DROPLET_IP"
    
    echo "✅ Сервер настроен!"
    echo ""
}

# Тестирование развертывания
test_deployment() {
    echo "🧪 Тестирование развертывания..."
    
    if [ -f ".env.droplet" ]; then
        source .env.droplet
    else
        read -p "Введите IP адрес вашего сервера: " DROPLET_IP
    fi
    
    if [ -z "$DROPLET_IP" ]; then
        echo "❌ IP адрес не указан"
        return 1
    fi
    
    echo "🚀 Запускаю тестовое развертывание..."
    
    # Делаем тестовый commit
    echo "# Тестовое развертывание $(date)" >> test-deploy.md
    git add test-deploy.md
    git commit -m "🧪 Тестовое развертывание"
    git push origin main
    
    echo ""
    echo "✅ Тестовый commit отправлен!"
    echo "🌐 Перейдите в GitHub Actions для отслеживания:"
    echo "   https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')/actions"
    echo ""
}

# Главное меню
main_menu() {
    while true; do
        echo "=== 🎯 ГЛАВНОЕ МЕНЮ ==="
        echo "1. 🔍 Проверить требования"
        echo "2. 🔐 Настроить GitHub CLI"
        echo "3. 🔑 Создать SSH ключ"
        echo "4. 🌊 Создать DigitalOcean Droplet"
        echo "5. 🔐 Настроить GitHub Secrets"
        echo "6. 🔧 Настроить сервер"
        echo "7. 🧪 Тестировать развертывание"
        echo "8. 🚀 Полная автоматическая настройка"
        echo "9. ❌ Выход"
        echo ""
        
        read -p "Выберите опцию (1-9): " choice
        
        case $choice in
            1) check_requirements ;;
            2) setup_github_cli ;;
            3) create_ssh_key ;;
            4) create_droplet ;;
            5) setup_github_secrets ;;
            6) setup_server ;;
            7) test_deployment ;;
            8) full_automation ;;
            9) echo "👋 До свидания!"; exit 0 ;;
            *) echo "❌ Неверный выбор. Попробуйте снова." ;;
        esac
        
        echo ""
        read -p "Нажмите Enter для продолжения..."
        echo ""
    done
}

# Полная автоматическая настройка
full_automation() {
    echo "🚀 ЗАПУСК ПОЛНОЙ АВТОМАТИЧЕСКОЙ НАСТРОЙКИ ==="
    echo ""
    
    check_requirements
    setup_github_cli
    create_ssh_key
    create_droplet
    setup_github_secrets
    setup_server
    test_deployment
    
    echo ""
    echo "🎉 ПОЛНАЯ НАСТРОЙКА ЗАВЕРШЕНА!"
    echo ""
    echo "=== 📋 ЧТО НАСТРОЕНО ==="
    echo "✅ GitHub CLI настроен"
    echo "✅ SSH ключ создан"
    echo "✅ DigitalOcean Droplet создан"
    echo "✅ GitHub Secrets добавлены"
    echo "✅ Сервер настроен"
    echo "✅ Тестовое развертывание запущено"
    echo ""
    echo "🌐 Ваш GraniVPN будет доступен по адресу:"
    echo "   http://$(cat .env.droplet | grep DROPLET_IP | cut -d'=' -f2)"
    echo ""
    echo "📊 Отслеживайте развертывание в GitHub Actions!"
}

# Запуск скрипта
if [ "$1" == "--auto" ]; then
    full_automation
else
    main_menu
fi
