# 💳 Руководство по настройке платежных систем GraniVPN

## 📋 Обзор платежных систем

GraniVPN поддерживает следующие платежные системы:

### 🌐 **Веб-платежи**
- **ЮKassa** - Основная платежная система для России
- **CloudPayments** - Альтернативная платежная система

### 📱 **Мобильные платежи**
- **Google Play Billing** - Для Android приложений
- **App Store In-App Purchases** - Для iOS приложений

## 🔧 Настройка ЮKassa (Яндекс.Касса)

### 1. Регистрация в ЮKassa

1. Перейдите на [ЮKassa](https://yookassa.ru/)
2. Нажмите "Подключиться"
3. Заполните форму регистрации:
   - ИНН организации
   - ОГРН/ОГРНИП
   - Банковские реквизиты
   - Контактная информация

### 2. Получение API ключей

После одобрения заявки:

1. Войдите в [личный кабинет ЮKassa](https://yookassa.ru/integration)
2. Перейдите в раздел "Настройки" → "API"
3. Скопируйте:
   - **Shop ID** (идентификатор магазина)
   - **Secret Key** (секретный ключ)

### 3. Настройка webhook'ов

1. В личном кабинете перейдите в "Настройки" → "Уведомления"
2. Добавьте URL для webhook'ов:
   ```
   https://api.granivpn.com/api/v1/payments/webhook/yandex
   ```
3. Выберите события для уведомлений:
   - `payment.succeeded` - Успешный платеж
   - `payment.canceled` - Отмененный платеж
   - `refund.succeeded` - Успешный возврат

### 4. Обновление конфигурации

Обновите файл `/opt/granivpn/.env`:

```env
# ЮKassa
YANDEX_SHOP_ID=your_shop_id_here
YANDEX_SECRET_KEY=your_secret_key_here
```

## 🔧 Настройка CloudPayments

### 1. Регистрация в CloudPayments

1. Перейдите на [CloudPayments](https://cloudpayments.ru/)
2. Нажмите "Подключиться"
3. Заполните заявку:
   - Данные организации
   - Банковские реквизиты
   - Контактная информация

### 2. Получение API ключей

После одобрения:

1. Войдите в [личный кабинет CloudPayments](https://merchant.cloudpayments.ru/)
2. Перейдите в "Настройки" → "API"
3. Скопируйте:
   - **Public ID** (публичный идентификатор)
   - **API Secret** (секретный ключ API)

### 3. Настройка webhook'ов

1. В личном кабинете перейдите в "Настройки" → "Уведомления"
2. Добавьте URL:
   ```
   https://api.granivpn.com/api/v1/payments/webhook/cloudpayments
   ```
3. Настройте события:
   - `PaymentSucceeded` - Успешный платеж
   - `PaymentFailed` - Неудачный платеж
   - `RefundSucceeded` - Успешный возврат

### 4. Обновление конфигурации

```env
# CloudPayments
CLOUDPAYMENTS_PUBLIC_ID=your_public_id_here
CLOUDPAYMENTS_API_SECRET=your_api_secret_here
```

## 📱 Настройка Google Play Billing

### 1. Подготовка приложения

1. Убедитесь, что приложение опубликовано в Google Play Store
2. В Google Play Console перейдите в "Монетизация" → "Подписки"
3. Создайте подписки:
   - `granivpn_basic` - Базовый план
   - `granivpn_premium` - Премиум план
   - `granivpn_enterprise` - Корпоративный план

### 2. Настройка цен

Для каждого плана установите цены:
- **Basic**: 299 ₽/месяц
- **Premium**: 599 ₽/месяц
- **Enterprise**: 999 ₽/месяц

### 3. Получение Service Account

1. В Google Play Console перейдите в "Настройки" → "API доступ"
2. Создайте Service Account
3. Скачайте JSON файл с ключами
4. Загрузите файл на сервер в `/opt/granivpn/keys/google-play-service-account.json`

### 4. Обновление конфигурации

```env
# Google Play Billing
GOOGLE_PLAY_SERVICE_ACCOUNT_PATH=/opt/granivpn/keys/google-play-service-account.json
GOOGLE_PLAY_PACKAGE_NAME=com.granivpn.mobile
```

## 📱 Настройка App Store In-App Purchases

### 1. Подготовка приложения

1. Убедитесь, что приложение опубликовано в App Store
2. В App Store Connect перейдите в "Монетизация" → "In-App Purchases"
3. Создайте подписки:
   - `granivpn_basic` - Базовый план
   - `granivpn_premium` - Премиум план
   - `granivpn_enterprise` - Корпоративный план

### 2. Настройка цен

Установите цены в App Store Connect:
- **Basic**: 299 ₽/месяц
- **Premium**: 599 ₽/месяц
- **Enterprise**: 999 ₽/месяц

### 3. Получение Shared Secret

1. В App Store Connect перейдите в "Пользователи и доступ"
2. Создайте API ключ с правами на In-App Purchases
3. Скопируйте Shared Secret

### 4. Обновление конфигурации

```env
# App Store
APP_STORE_SHARED_SECRET=your_shared_secret_here
APP_STORE_BUNDLE_ID=com.granivpn.mobile
```

## 🔒 Безопасность

### 1. Проверка подписей webhook'ов

#### ЮKassa
```python
import hmac
import hashlib

def verify_yandex_signature(data, signature, secret_key):
    expected_signature = hmac.new(
        secret_key.encode('utf-8'),
        data.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(signature, expected_signature)
```

#### CloudPayments
```python
def verify_cloudpayments_signature(data, signature, secret_key):
    # Проверка подписи CloudPayments
    expected_signature = hmac.new(
        secret_key.encode('utf-8'),
        data.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(signature, expected_signature)
```

### 2. Защита API ключей

- ✅ Храните ключи в переменных окружения
- ✅ Не коммитьте ключи в Git
- ✅ Используйте разные ключи для тестирования и продакшена
- ✅ Регулярно ротируйте ключи

### 3. SSL сертификаты

- ✅ Используйте HTTPS для всех webhook'ов
- ✅ Проверяйте SSL сертификаты платежных систем
- ✅ Используйте современные шифры

## 🧪 Тестирование

### 1. Тестовые карты

#### ЮKassa
- **Успешный платеж**: `1111 1111 1111 1026`
- **Недостаточно средств**: `1111 1111 1111 1047`
- **Карта заблокирована**: `1111 1111 1111 1101`

#### CloudPayments
- **Успешный платеж**: `4111 1111 1111 1111`
- **Недостаточно средств**: `4000 0000 0000 0002`
- **Карта заблокирована**: `4000 0000 0000 0001`

### 2. Тестирование webhook'ов

```bash
# Тест webhook'а ЮKassa
curl -X POST https://api.granivpn.com/api/v1/payments/webhook/yandex \
  -H "Content-Type: application/json" \
  -d '{
    "type": "notification",
    "event": "payment.succeeded",
    "object": {
      "id": "test_payment_id",
      "status": "succeeded",
      "amount": {
        "value": "299.00",
        "currency": "RUB"
      },
      "metadata": {
        "user_id": 1,
        "subscription_plan": "basic"
      }
    }
  }'
```

### 3. Тестирование мобильных платежей

#### Google Play
```bash
# Тест проверки покупки
curl -X POST https://api.granivpn.com/api/v1/payments/verify/google-play \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "purchaseToken": "test_token",
    "productId": "granivpn_basic"
  }'
```

#### App Store
```bash
# Тест проверки покупки
curl -X POST https://api.granivpn.com/api/v1/payments/verify/app-store \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "receiptData": "test_receipt_data",
    "productId": "granivpn_basic"
  }'
```

## 📊 Мониторинг платежей

### 1. Логи платежей

```bash
# Просмотр логов платежей
docker logs granivpn-backend | grep -i payment

# Логи webhook'ов
docker logs granivpn-backend | grep -i webhook
```

### 2. Метрики в Grafana

- 📈 Количество платежей по времени
- 💰 Общая сумма платежей
- 📊 Конверсия платежей
- 🔍 Статистика по методам оплаты

### 3. Алерты

Настройте алерты для:
- ⚠️ Высокого процента неудачных платежей
- 🚨 Отсутствия webhook'ов от платежных систем
- 💸 Аномальных сумм платежей

## 🔄 Автоматизация

### 1. Автоматическое обновление подписок

```bash
# Cron задача для проверки истекших подписок
0 2 * * * /opt/granivpn/scripts/check_expired_subscriptions.sh
```

### 2. Автоматические возвраты

```bash
# Скрипт для обработки возвратов
0 3 * * * /opt/granivpn/scripts/process_refunds.sh
```

### 3. Резервное копирование платежных данных

```bash
# Бэкап платежных данных
0 4 * * * /opt/granivpn/scripts/backup_payment_data.sh
```

## 🆘 Устранение неполадок

### Частые проблемы:

#### 1. Webhook'и не приходят
```bash
# Проверка доступности webhook URL
curl -I https://api.granivpn.com/api/v1/payments/webhook/yandex

# Проверка SSL сертификата
openssl s_client -connect api.granivpn.com:443 -servername api.granivpn.com
```

#### 2. Ошибки аутентификации
```bash
# Проверка API ключей
curl -u "shop_id:secret_key" https://api.yookassa.ru/v3/payments
```

#### 3. Платежи не создаются
```bash
# Проверка логов
docker logs granivpn-backend | grep -i "payment.*error"

# Проверка конфигурации
docker exec granivpn-backend env | grep -i payment
```

#### 4. Мобильные платежи не работают
```bash
# Проверка Google Play API
curl -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  https://androidpublisher.googleapis.com/androidpublisher/v3/applications/com.granivpn.mobile/purchases/subscriptions/granivpn_basic/tokens/test_token
```

## 📞 Поддержка

### Контакты платежных систем:

- **ЮKassa**: support@yookassa.ru
- **CloudPayments**: support@cloudpayments.ru
- **Google Play**: developer-support@google.com
- **App Store**: developer-support@apple.com

### Полезные ссылки:

- [Документация ЮKassa](https://yookassa.ru/developers/api)
- [Документация CloudPayments](https://developers.cloudpayments.ru/)
- [Google Play Billing](https://developer.android.com/google/play/billing)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)

---

## 🎯 Чек-лист настройки

### ✅ ЮKassa
- [ ] Регистрация в ЮKassa
- [ ] Получение Shop ID и Secret Key
- [ ] Настройка webhook'ов
- [ ] Обновление конфигурации
- [ ] Тестирование платежей

### ✅ CloudPayments
- [ ] Регистрация в CloudPayments
- [ ] Получение Public ID и API Secret
- [ ] Настройка webhook'ов
- [ ] Обновление конфигурации
- [ ] Тестирование платежей

### ✅ Google Play Billing
- [ ] Публикация приложения
- [ ] Создание подписок
- [ ] Настройка цен
- [ ] Получение Service Account
- [ ] Тестирование покупок

### ✅ App Store In-App Purchases
- [ ] Публикация приложения
- [ ] Создание подписок
- [ ] Настройка цен
- [ ] Получение Shared Secret
- [ ] Тестирование покупок

### ✅ Безопасность
- [ ] Проверка подписей webhook'ов
- [ ] Защита API ключей
- [ ] SSL сертификаты
- [ ] Мониторинг платежей
- [ ] Настройка алертов

---

**🎉 Поздравляем! Платежные системы успешно настроены!**
