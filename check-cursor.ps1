# Скрипт для проверки папки .cursor
Write-Host "Проверяем папку .cursor..."

$cursorPath = "C:\Users\railt\.cursor"

if (Test-Path $cursorPath) {
    Write-Host "Папка .cursor найдена!"
    Write-Host "Содержимое:"
    
    try {
        $items = Get-ChildItem $cursorPath -Force -ErrorAction Stop
        foreach ($item in $items) {
            $type = if ($item.PSIsContainer) { "Папка" } else { "Файл" }
            $size = if ($item.PSIsContainer) { "" } else { " ($($item.Length) байт)" }
            Write-Host "  $type: $($item.Name)$size"
        }
        
        # Проверяем подпапки
        Write-Host "`nПроверяем подпапки..."
        $subfolders = Get-ChildItem $cursorPath -Directory -Force -ErrorAction Stop
        foreach ($folder in $subfolders) {
            Write-Host "`nПапка: $($folder.Name)"
            try {
                $files = Get-ChildItem $folder.FullName -File -Force -ErrorAction Stop | Select-Object -First 5
                foreach ($file in $files) {
                    Write-Host "  Файл: $($file.Name) ($($file.Length) байт)"
                }
                if ((Get-ChildItem $folder.FullName -File -Force).Count -gt 5) {
                    Write-Host "  ... и еще файлы"
                }
            } catch {
                Write-Host "  Ошибка доступа к папке"
            }
        }
        
    } catch {
        Write-Host "Ошибка при чтении папки: $($_.Exception.Message)"
    }
} else {
    Write-Host "Папка .cursor не найдена!"
}

Write-Host "`nПроверка завершена."

