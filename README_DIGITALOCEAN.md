# 🌊 GraniVPN - Развертывание в DigitalOcean

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![DigitalOcean](https://img.shields.io/badge/DigitalOcean-Ready-0080FF.svg)](https://digitalocean.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 О проекте

GraniVPN - это полнофункциональная VPN платформа с веб-интерфейсом, админ панелью и мобильным приложением. Проект готов к развертыванию в DigitalOcean с использованием Docker.

## 🚀 Быстрый старт (5 минут)

### 1. Создайте Droplet в DigitalOcean
- Ubuntu 22.04 LTS
- 2GB RAM, 1 CPU
- Ваш SSH ключ

### 2. Подключитесь к серверу
```bash
ssh root@YOUR_SERVER_IP
```

### 3. Разверните приложение
```bash
# Обновление системы
apt update && apt upgrade -y

# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
apt install docker-compose-plugin -y

# Клонирование проекта
cd ~ && git clone https://github.com/railtamaew/granivpn-v2.git
cd granivpn-v2

# Запуск развертывания
chmod +x deploy-digitalocean.sh
./deploy-digitalocean.sh
```

### 4. Готово! 🎉
- Backend API: http://YOUR_SERVER_IP:8000
- Admin Panel: http://YOUR_SERVER_IP:3000
- Mobile App: http://YOUR_SERVER_IP:8080

## 📋 Что включено

### 🔧 Backend (Python FastAPI)
- RESTful API для управления VPN
- Аутентификация и авторизация
- Управление пользователями и платежами
- Мониторинг системы

### 🖥️ Admin Panel (React)
- Веб-интерфейс для администраторов
- Управление пользователями
- Мониторинг и аналитика
- Настройки системы

### 📱 Mobile App (Flutter Web)
- Мобильное приложение для пользователей
- Подключение к VPN серверам
- Управление подпиской
- Кроссплатформенность

### 🛡️ WireGuard VPN Server
- Высокопроизводительный VPN протокол
- Автоматическая генерация конфигураций
- Масштабируемость

### 🗄️ База данных и кэш
- PostgreSQL для основных данных
- Redis для кэширования
- Автоматические бэкапы

## 🐳 Docker архитектура

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │    │   Admin Panel   │    │   Mobile App    │
│   Port 80/443   │    │   Port 3000     │    │   Port 8080     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Backend API   │
                    │   Port 8000     │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │     Redis       │    │   WireGuard     │
│   Port 5432     │    │   Port 6379     │    │   Port 51820    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 💰 Стоимость

- **DigitalOcean Droplet**: $12/месяц
- **Домен**: ~$10/год
- **SSL сертификат**: Бесплатно (Let's Encrypt)
- **Итого**: ~$154/год

## 📚 Документация

- **[DIGITALOCEAN_DEPLOYMENT.md](DIGITALOCEAN_DEPLOYMENT.md)** - Подробное руководство
- **[QUICK_DEPLOY_DIGITALOCEAN.md](QUICK_DEPLOY_DIGITALOCEAN.md)** - Быстрый старт
- **[DEPLOYMENT_READY.md](DEPLOYMENT_READY.md)** - Отчет о готовности

## 🔒 Безопасность

- ✅ Firewall (UFW)
- ✅ SSH защита
- ✅ SSL/TLS шифрование
- ✅ Docker изоляция
- ✅ Переменные окружения
- ✅ Автоматические обновления

## 📊 Мониторинг

- ✅ Логи всех сервисов
- ✅ Статистика Docker
- ✅ Мониторинг ресурсов
- ✅ Автоматические бэкапы
- ✅ Health checks

## 🚀 Развертывание

### Локальная разработка
```bash
# Запуск всех сервисов
./start-all-services.sh

# Проверка статуса
./monitor-services.sh

# Остановка всех сервисов
./stop-all-services.sh
```

### Продакшн (DigitalOcean)
```bash
# Автоматическое развертывание
./deploy-digitalocean.sh

# Управление контейнерами
docker compose -f docker-compose.production.yml up -d
docker compose -f docker-compose.production.yml down
```

## 🛠️ Технологии

- **Backend**: Python FastAPI, SQLAlchemy, Alembic
- **Frontend**: React, TypeScript, Material-UI
- **Mobile**: Flutter, Dart
- **Database**: PostgreSQL, Redis
- **VPN**: WireGuard
- **Infrastructure**: Docker, Docker Compose, Nginx
- **Cloud**: DigitalOcean

## 📁 Структура проекта

```
granivpn/
├── backend/                    # Python FastAPI сервер
├── admin-panel/               # React админ панель
├── mobile-app/                # Flutter мобильное приложение
├── nginx/                     # Nginx конфигурации
├── docker-compose.production.yml  # Docker Compose для продакшн
├── deploy-digitalocean.sh     # Скрипт развертывания
├── env.production             # Переменные окружения
└── docs/                      # Документация
```

## 🆘 Поддержка

### При возникновении проблем
1. Проверьте логи: `docker logs CONTAINER_NAME`
2. Проверьте статус: `docker ps -a`
3. Обратитесь к документации
4. Создайте issue в GitHub

### Полезные команды
```bash
# Статус всех сервисов
docker compose -f docker-compose.production.yml ps

# Логи в реальном времени
docker compose -f docker-compose.production.yml logs -f

# Перезапуск сервиса
docker compose -f docker-compose.production.yml restart backend

# Вход в контейнер
docker exec -it granivpn-backend bash
```

## 🤝 Вклад в проект

1. Fork репозитория
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для деталей.

## 🙏 Благодарности

- [DigitalOcean](https://digitalocean.com) за отличную облачную платформу
- [Docker](https://docker.com) за контейнеризацию
- [FastAPI](https://fastapi.tiangolo.com) за современный Python веб-фреймворк
- [React](https://reactjs.org) за JavaScript библиотеку
- [Flutter](https://flutter.dev) за кроссплатформенную разработку

## 📞 Контакты

- **GitHub**: [railtamaew/granivpn-v2](https://github.com/railtamaew/granivpn-v2)
- **Issues**: [GitHub Issues](https://github.com/railtamaew/granivpn-v2/issues)

---

**⭐ Если проект вам понравился, поставьте звездочку на GitHub!**

*GraniVPN v2 - Современная VPN платформа для DigitalOcean*
