# 🚀 GraniVPN - Быстрый запуск

## 📋 Требования
- Python 3.8+
- Node.js 16+
- Flutter 3.0+
- curl (для проверки статуса)

## 🚀 Быстрый запуск всех сервисов

### 1. Автоматический запуск
```bash
./start-all-services.sh
```

### 2. Проверка статуса
```bash
./monitor-services.sh
```

### 3. Остановка всех сервисов
```bash
./stop-all-services.sh
```

## 🔧 Ручной запуск

### Backend (Python FastAPI)
```bash
cd backend
python3 main_demo.py
```
**Порт:** 8000
**API Docs:** http://localhost:8000/docs

### Admin Panel (React)
```bash
cd admin-panel
npm install
npm start
```
**Порт:** 3000
**URL:** http://localhost:3000

### Mobile App (Flutter Web)
```bash
cd mobile-app
flutter run -d chrome --web-port 8080
```
**Порт:** 8080
**URL:** http://localhost:8080

## 🌐 Доступные ссылки

| Сервис | URL | Описание |
|--------|-----|----------|
| 🔧 Backend API | http://localhost:8000 | Python FastAPI сервер |
| 📚 API Docs | http://localhost:8000/docs | Swagger документация |
| 🖥️ Admin Panel | http://localhost:3000 | React админ панель |
| 📱 Mobile App | http://localhost:8080 | Flutter веб приложение |

## 📊 Мониторинг

### Проверка статуса всех сервисов
```bash
./monitor-services.sh
```

### Проверка конкретного сервиса
```bash
# Backend
curl http://localhost:8000/health

# Admin Panel
curl http://localhost:3000

# Mobile App
curl http://localhost:8080
```

## 🛠️ Устранение проблем

### Backend не запускается
1. Проверьте Python версию: `python3 --version`
2. Установите зависимости: `cd backend && pip install -r requirements.txt`
3. Проверьте логи: `cat backend.log`

### Admin Panel не запускается
1. Установите зависимости: `cd admin-panel && npm install`
2. Проверьте логи: `cat admin-panel.log`
3. Убедитесь, что порт 3000 свободен

### Mobile App не запускается
1. Проверьте Flutter: `flutter doctor`
2. Проверьте логи: `cat mobile-app.log`
3. Убедитесь, что порт 8080 свободен

## 📁 Структура проекта
```
grani/
├── backend/           # Python FastAPI сервер
├── admin-panel/       # React админ панель
├── mobile-app/        # Flutter мобильное приложение
├── start-all-services.sh    # Скрипт запуска всех сервисов
├── stop-all-services.sh     # Скрипт остановки всех сервисов
├── monitor-services.sh      # Скрипт мониторинга
└── README.md          # Основная документация
```

## 🎯 Следующие шаги
1. Откройте http://localhost:3000 в браузере для админ панели
2. Откройте http://localhost:8080 для мобильного приложения
3. Изучите API документацию на http://localhost:8000/docs
4. Настройте базу данных и конфигурацию

## 📞 Поддержка
При возникновении проблем проверьте логи соответствующих сервисов или обратитесь к основной документации проекта.
