# 🔑 НАСТРОЙКА SSH ДЛЯ GITHUB

## 🚨 Проблема
GitHub не принимает push из-за отсутствия SSH ключа.

## 🔧 Решение

### Шаг 1: Добавьте SSH ключ в GitHub

1. **Скопируйте ваш публичный ключ:**
```bash
cat ~/.ssh/id_rsa.pub
```

2. **Перейдите в GitHub:**
   - Откройте https://github.com/settings/keys
   - Нажмите **New SSH key**

3. **Добавьте ключ:**
   - **Title**: `MacBook Pro Rail`
   - **Key**: Вставьте содержимое `~/.ssh/id_rsa.pub`
   - Нажмите **Add SSH key**

### Шаг 2: Проверьте подключение

```bash
ssh -T git@github.com
```

Должно появиться: `Hi railtamaew! You've successfully authenticated...`

### Шаг 3: Отправьте код

```bash
git push origin main
```

## 🔄 Альтернативное решение (HTTPS с токеном)

Если SSH не работает, используйте HTTPS с токеном:

1. **Создайте новый токен:**
   - https://github.com/settings/tokens
   - **Generate new token (classic)**
   - Выберите **repo** права
   - Скопируйте токен

2. **Измените remote URL:**
```bash
git remote set-url origin https://github.com/railtamaew/granivpn-v2.git
```

3. **Отправьте с токеном:**
```bash
git push https://YOUR_TOKEN@github.com/railtamaew/granivpn-v2.git main
```

## 📋 Ваш SSH ключ

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCki4pljZ+MiRhNEpgSuXQDqJ55h8d+LHdz6nIaJ
vL/EnKuL9nt8nlWobr5AZa7Ao3GHSfQnTH4v7xl3s2HEyZ9YA+qQLBXsDJ3Kzn9liCblEE8LOWZ1f
ZXvufKbzWgCr+xTD4HSPmVjUYZX3HFlFrcoYasY2nkVAygQltGUqb6WRrjdn+L0csoTY2V7KM0c2Y
Qts595CYZGX15p4K95IaoT7SP56BIgcYkeTpmUQ1ehwtx1W+GnI/UmBPQ4PpczLJCvXujsmz869tt
bDDXpOi5IiHd8Rqw+N1z7vaKtXGNjGcTwFgPw+U6xmKJ22DmRteOvgeE400lixSleNDdii4BKWzN7
gOdWuh1KJFEUfj4qBlOa1Y3pgquKD7la3yTimPoHqoRAe5TdX53xCtwN9TqLh/jipDC+O6UFXXZrh
LDoQMWI6f5DANNBh8oIIsSeRr5FWYSk0URc4BdfBxSe1p5ZKgCTzvm7ts8TwgiZckkRgj8DpX+W73
b5Bipa5nLZt6rTKvrtr3wAlqGYaS81nXkkxXLbwElfUvMNej2WnUbFq44yXgaRHuOGMKfBwN095c9
dwPxoDidlrV7zJgjGvMdBp56/BGppagVkoQ45so1nuoJPM8Ic9Y/w/l47QcpVDoNa2Z+5ED6qL99A
O3mZKl2EdM7Mk/BGt8IFv3D/+vwzw== granivpn@example.com
```

## 🎯 После настройки

1. ✅ SSH ключ добавлен в GitHub
2. ✅ Проверено подключение
3. ✅ Код отправлен в репозиторий
4. ✅ GitHub Actions запустится автоматически

---

*Инструкция по настройке SSH для GraniVPN*
*Дата: $(date)*
