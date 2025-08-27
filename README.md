# 🚀 GraniVPN - Полнофункциональная VPN платформа

**GraniVPN** - это современная VPN платформа с открытым исходным кодом, построенная на базе WireGuard протокола. Проект включает в себя backend API, административную панель и мобильное приложение.

## ✨ Основные возможности

### 🔐 VPN функциональность
- **WireGuard протокол** - современный, быстрый и безопасный VPN протокол
- **Множественные серверы** - поддержка нескольких VPN серверов в разных локациях
- **Автоматическое управление ключами** - генерация и управление криптографическими ключами
- **Ограничение устройств** - контроль количества подключенных устройств на пользователя

### 💳 Система подписок
- **Гибкие планы** - от бесплатного до корпоративного
- **Автоматическое продление** - настраиваемые планы подписок
- **Множественные валюты** - поддержка различных платежных систем
- **Управление лимитами** - контроль функций и возможностей по планам

### 📊 Мониторинг и аналитика
- **Системные метрики** - CPU, память, диск, сеть в реальном времени
- **Метрики приложения** - пользователи, устройства, платежи, подписки
- **Производительность** - время ответа API, активные соединения, топ процессов
- **Автоматическое обновление** - метрики обновляются каждые 30 секунд

### 🛡️ Безопасность
- **JWT аутентификация** - безопасная система входа
- **Роли и права** - разделение доступа между пользователями и администраторами
- **Шифрование данных** - защита конфиденциальной информации
- **Логирование действий** - аудит всех операций в системе

## 🏗️ Архитектура проекта

```
grani/
├── backend/                 # FastAPI backend
│   ├── core/               # Основные модули
│   │   ├── config.py       # Конфигурация приложения
│   │   ├── database.py     # Настройки базы данных
│   │   ├── security.py     # Аутентификация и безопасность
│   │   ├── wireguard.py    # Управление WireGuard VPN
│   │   └── monitoring.py   # Система мониторинга
│   ├── models/             # SQLAlchemy модели
│   ├── schemas/            # Pydantic схемы
│   ├── api/                # API endpoints
│   └── main_demo.py        # Основное приложение
├── admin-panel/            # React административная панель
│   ├── src/
│   │   ├── pages/          # Страницы приложения
│   │   ├── components/     # React компоненты
│   │   └── store/          # Redux store
├── mobile-app/             # Flutter мобильное приложение
│   ├── lib/
│   │   ├── screens/        # Экраны приложения
│   │   ├── providers/      # State management
│   │   └── utils/          # Утилиты и константы
├── figma/                  # Дизайн макеты
├── docker-compose.yml      # Docker конфигурация
└── README.md               # Документация
```

## 🚀 Быстрый старт

### Предварительные требования
- Docker и Docker Compose
- Python 3.9+
- Node.js 16+
- Flutter 3.0+

### 1. Клонирование проекта
```bash
git clone https://github.com/your-username/grani.git
cd grani
```

### 2. Создание .env файла
```bash
cp .env.example .env
# Отредактируйте .env файл с вашими настройками
```

### 3. Запуск с Docker Compose
```bash
./start.sh
```

Или вручную:
```bash
docker-compose up -d
```

### 4. Создание администратора
```bash
./create-admin.sh
```

## 🌐 Доступные URL

После запуска будут доступны:

- **Backend API**: http://localhost:8000
- **API Документация**: http://localhost:8000/docs
- **Admin Panel**: http://localhost:3000
- **Flutter Web**: http://localhost:8080

## 🔧 Технологический стек

### Backend
- **FastAPI** - современный веб-фреймворк для Python
- **SQLAlchemy** - ORM для работы с базой данных
- **PostgreSQL** - основная база данных
- **Redis** - кэширование и сессии
- **WireGuard** - VPN протокол
- **JWT** - аутентификация

### Admin Panel
- **React 18** - пользовательский интерфейс
- **TypeScript** - типизированный JavaScript
- **Material-UI** - компоненты интерфейса
- **Redux Toolkit** - управление состоянием
- **Axios** - HTTP клиент

### Mobile App
- **Flutter** - кроссплатформенная разработка
- **Dart** - язык программирования
- **Provider** - state management
- **HTTP** - API интеграция
- **SharedPreferences** - локальное хранение

### DevOps
- **Docker** - контейнеризация
- **Docker Compose** - оркестрация сервисов
- **Nginx** - веб-сервер и прокси
- **PostgreSQL** - база данных
- **Redis** - кэш и сессии

## 📱 Дизайн мобильного приложения

Мобильное приложение полностью сверстано согласно макетам Figma и включает:

- **Splash Screen** - анимированный экран загрузки с логотипом
- **Login Screen** - современная форма входа с валидацией
- **VPN Connect** - большой круг подключения с анимированными кольцами
- **Servers** - список серверов с метриками нагрузки и пинга
- **Profile** - профиль пользователя с настройками и меню

### Цветовая схема (из Figma)
- **Primary**: #182D3D (темно-синий)
- **Background**: #F7F4F8 (светло-серый)
- **Card Background**: #F4F6F8 (серый)
- **Success**: #4CAF50 (зеленый)
- **Error**: #F44336 (красный)
- **Warning**: #FF9800 (оранжевый)

## 🔌 API Endpoints

### Аутентификация
- `POST /api/v1/auth/register` - регистрация пользователя
- `POST /api/v1/auth/login` - вход в систему
- `GET /api/v1/auth/me` - информация о текущем пользователе

### Пользователи
- `GET /api/v1/users` - список пользователей (админ)
- `GET /api/v1/users/{id}` - информация о пользователе
- `PUT /api/v1/users/{id}` - обновление пользователя
- `DELETE /api/v1/users/{id}` - удаление пользователя

### WireGuard VPN
- `GET /api/v1/wireguard/servers` - список VPN серверов
- `POST /api/v1/wireguard/connect` - подключение к VPN
- `POST /api/v1/wireguard/disconnect/{device_id}` - отключение от VPN
- `GET /api/v1/wireguard/status/{device_id}` - статус подключения
- `GET /api/v1/wireguard/devices` - список устройств пользователя

### Подписки
- `GET /api/v1/subscriptions/plans` - доступные планы
- `GET /api/v1/subscriptions/my` - текущая подписка
- `POST /api/v1/subscriptions/upgrade` - обновление плана
- `GET /api/v1/subscriptions/admin/all` - все подписки (админ)

### Мониторинг
- `GET /api/v1/monitoring/system` - системные метрики
- `GET /api/v1/monitoring/application` - метрики приложения
- `GET /api/v1/monitoring/performance` - метрики производительности
- `GET /api/v1/monitoring/all` - все метрики

## 📊 Реализованная функциональность

### ✅ Backend
- [x] FastAPI приложение с CORS
- [x] SQLAlchemy модели (User, Device, Payment, Subscription)
- [x] JWT аутентификация
- [x] WireGuard VPN управление
- [x] Система подписок
- [x] Мониторинг и метрики
- [x] API endpoints для всех функций
- [x] Демо данные для тестирования

### ✅ Admin Panel
- [x] React приложение с TypeScript
- [x] Material-UI компоненты
- [x] Redux state management
- [x] Защищенные маршруты
- [x] Страницы: Dashboard, Users, Payments, WireGuard, Monitoring, Settings
- [x] Адаптивный дизайн
- [x] Интеграция с API

### ✅ Mobile App
- [x] Flutter приложение
- [x] Дизайн согласно Figma макетам
- [x] Provider state management
- [x] Анимации и переходы
- [x] Экраны: Splash, Login, Home, VPN Connect, Servers, Profile
- [x] Интеграция с API
- [x] Локальное хранение данных

### ✅ DevOps
- [x] Docker контейнеризация
- [x] Docker Compose оркестрация
- [x] Nginx конфигурация
- [x] PostgreSQL база данных
- [x] Redis кэш
- [x] Автоматический запуск

## 🚀 Команды разработки

### Backend
```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# или
venv\Scripts\activate     # Windows
pip install -r requirements.txt
python3 main_demo.py
```

### Admin Panel
```bash
cd admin-panel
npm install
npm start
```

### Mobile App
```bash
cd mobile-app
flutter pub get
flutter run
```

## 📈 Следующие шаги

1. **Тестирование** - проверить все компоненты системы
2. **WireGuard настройка** - настроить реальные VPN серверы
3. **Платежная система** - интеграция с платежными провайдерами
4. **Мониторинг** - настройка алертов и уведомлений
5. **Деплой** - развертывание на продакшн сервере
6. **SSL сертификаты** - настройка HTTPS
7. **Бэкапы** - автоматическое резервное копирование
8. **Масштабирование** - добавление новых серверов

## 🤝 Вклад в проект

Мы приветствуем вклад в развитие проекта! Пожалуйста:

1. Форкните репозиторий
2. Создайте ветку для новой функции
3. Внесите изменения
4. Создайте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл `LICENSE` для подробностей.

## 📞 Поддержка

Если у вас есть вопросы или предложения:

- Создайте Issue в GitHub
- Напишите на email: support@granivpn.com
- Присоединитесь к нашему Discord серверу

---

**GraniVPN** - Безопасность и скорость в одном приложении! 🛡️⚡





