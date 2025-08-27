# 🚀 План развертывания GraniVPN для совместного доступа

## 📋 Обзор вариантов

### 🥇 **Рекомендуемый: DigitalOcean + GitHub Actions**
- **Стоимость**: ~$20-40/месяц
- **Сложность**: Средняя
- **Контроль**: Полный
- **Мониторинг**: Встроенный

### 🥈 **Альтернативный: AWS/GCP**
- **Стоимость**: ~$50-100/месяц
- **Сложность**: Высокая
- **Контроль**: Максимальный
- **Мониторинг**: Продвинутый

### 🥉 **Простой: VPS + Docker**
- **Стоимость**: ~$10-20/месяц
- **Сложность**: Низкая
- **Контроль**: Полный
- **Мониторинг**: Базовый

## 🎯 Выбранный план: DigitalOcean + GitHub Actions

### 📋 **Этапы развертывания:**

#### **1. Подготовка репозитория**
- [ ] Создать GitHub репозиторий
- [ ] Настроить GitHub Actions
- [ ] Добавить секреты (API ключи, пароли)
- [ ] Настроить автоматический деплой

#### **2. Настройка DigitalOcean**
- [ ] Создать Droplet (Ubuntu 22.04)
- [ ] Настроить домен и DNS
- [ ] Установить Docker и Docker Compose
- [ ] Настроить SSL сертификаты

#### **3. Конфигурация доступа**
- [ ] Настроить SSH ключи для обоих
- [ ] Создать пользователей с правами
- [ ] Настроить мониторинг
- [ ] Настроить бэкапы

#### **4. Развертывание приложения**
- [ ] Автоматический деплой из GitHub
- [ ] Настройка переменных окружения
- [ ] Запуск всех сервисов
- [ ] Тестирование функциональности

## 🔧 **Детальная инструкция**

### **Шаг 1: Создание GitHub репозитория**

```bash
# 1. Создать новый репозиторий на GitHub
# 2. Загрузить весь код проекта
# 3. Настроить GitHub Actions
```

### **Шаг 2: Настройка DigitalOcean**

```bash
# 1. Создать аккаунт на DigitalOcean
# 2. Создать Droplet:
#    - Ubuntu 22.04 LTS
#    - 4GB RAM, 2 CPU, 80GB SSD
#    - Регион: Frankfurt (ближе к России)
# 3. Настроить домен (например: granivpn.com)
```

### **Шаг 3: Настройка сервера**

```bash
# Подключение к серверу
ssh root@your-server-ip

# Обновление системы
apt update && apt upgrade -y

# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Установка Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Создание пользователей
adduser admin
usermod -aG docker admin
usermod -aG sudo admin

# Настройка SSH ключей
mkdir -p /home/admin/.ssh
cp ~/.ssh/authorized_keys /home/admin/.ssh/
chown -R admin:admin /home/admin/.ssh
```

### **Шаг 4: Настройка GitHub Actions**

```yaml
# .github/workflows/deploy.yml
name: Deploy to DigitalOcean

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to DigitalOcean
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /opt/granivpn
          git pull origin main
          docker-compose -f docker-compose.production.yml down
          docker-compose -f docker-compose.production.yml up -d --build
```

### **Шаг 5: Настройка мониторинга**

```bash
# Установка мониторинга
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  grafana/grafana

# Настройка алертов
# - Email уведомления
# - Telegram бот
# - Slack интеграция
```

## 🔐 **Безопасность и доступ**

### **SSH доступ для обоих:**
```bash
# Создание SSH ключей
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# Добавление ключей на сервер
ssh-copy-id admin@your-server-ip

# Настройка sudo без пароля
echo "admin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/admin
```

### **Мониторинг доступа:**
```bash
# Логирование SSH подключений
tail -f /var/log/auth.log

# Мониторинг активных сессий
who
w

# Уведомления о новых подключениях
```

## 📊 **Мониторинг и управление**

### **Веб-интерфейсы:**
- **GraniVPN**: https://granivpn.com
- **Admin Panel**: https://admin.granivpn.com
- **API**: https://api.granivpn.com
- **Grafana**: https://granivpn.com:3000
- **Prometheus**: https://granivpn.com:9090

### **Команды управления:**
```bash
# Статус сервисов
docker-compose -f docker-compose.production.yml ps

# Логи приложения
docker-compose -f docker-compose.production.yml logs -f

# Перезапуск сервисов
docker-compose -f docker-compose.production.yml restart

# Обновление приложения
git pull && docker-compose -f docker-compose.production.yml up -d --build
```

## 💰 **Стоимость**

### **DigitalOcean Droplet:**
- **Basic**: $24/месяц (4GB RAM, 2 CPU, 80GB SSD)
- **Standard**: $48/месяц (8GB RAM, 4 CPU, 160GB SSD)

### **Дополнительные расходы:**
- **Домен**: ~$10/год
- **SSL сертификаты**: Бесплатно (Let's Encrypt)
- **Резервные копии**: $2/месяц

**Итого: ~$26-50/месяц**

## 🚀 **Альтернативные варианты**

### **VPS провайдеры:**
1. **Vultr**: $20/месяц (4GB RAM)
2. **Linode**: $24/месяц (4GB RAM)
3. **Hetzner**: €20/месяц (8GB RAM)

### **Облачные платформы:**
1. **AWS EC2**: $30-80/месяц
2. **Google Cloud**: $25-70/месяц
3. **Azure**: $30-75/месяц

## 📋 **Чек-лист развертывания**

### **Подготовка:**
- [ ] Создать GitHub репозиторий
- [ ] Загрузить код проекта
- [ ] Настроить GitHub Actions
- [ ] Создать аккаунт DigitalOcean
- [ ] Купить домен

### **Настройка сервера:**
- [ ] Создать Droplet
- [ ] Настроить SSH доступ
- [ ] Установить Docker
- [ ] Настроить пользователей
- [ ] Настроить домен и DNS

### **Развертывание:**
- [ ] Настроить переменные окружения
- [ ] Запустить первый деплой
- [ ] Настроить SSL сертификаты
- [ ] Протестировать все функции
- [ ] Настроить мониторинг

### **Безопасность:**
- [ ] Настроить файрвол
- [ ] Настроить бэкапы
- [ ] Настроить алерты
- [ ] Настроить логирование
- [ ] Протестировать безопасность

---

## 🎯 **Рекомендация**

**Для начала рекомендую DigitalOcean + GitHub Actions**, так как:
- ✅ Простая настройка
- ✅ Надежная инфраструктура
- ✅ Хорошая документация
- ✅ Доступная цена
- ✅ Возможность масштабирования

**Готовы начать развертывание?** 🚀
