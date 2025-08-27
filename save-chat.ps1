# Скрипт для сохранения чатов Cursor
# Запускать после важных сессий

param(
    [string]$ChatName = "chat-backup",
    [string]$ProjectName = "remeslo-web"
)

# Создаем папки если их нет
$folders = @("docs", "docs/chats", "docs/decisions", "docs/solutions", "docs/notes")
foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder
        Write-Host "Создана папка: $folder"
    }
}

# Получаем текущую дату
$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Создаем файл с информацией о сессии
$sessionFile = "docs/chats/$date-$ChatName.md"

$content = @"
# Чат: $ChatName

**Дата:** $date  
**Время:** $timestamp  
**Проект:** $ProjectName

## Что было сделано
[Опишите что обсуждалось/решили]

## Важные решения
- [ ] Решение 1
- [ ] Решение 2

## Код
\`\`\`
// Важный код здесь
\`\`\`

## Проблемы
- [ ] Проблема 1
- [ ] Проблема 2

## Следующие шаги
- [ ] Шаг 1
- [ ] Шаг 2

---
*Автоматически создано $timestamp*
"@

$content | Out-File -FilePath $sessionFile -Encoding UTF8

Write-Host "Чат сохранен в: $sessionFile"
Write-Host "Не забудьте заполнить содержимое файла!"

# Открываем файл в редакторе
if (Get-Command "code" -ErrorAction SilentlyContinue) {
    code $sessionFile
} else {
    notepad $sessionFile
}

