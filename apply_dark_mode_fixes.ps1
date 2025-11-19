# Script para aplicar mejoras al modo oscuro
$cssFile = "style.css"
$content = Get-Content $cssFile -Raw

# 1. Agregar transiciones suaves a html y body
$content = $content -replace '(html \{[^}]*)(scroll-behavior: smooth;)([^}]*\})', '$1$2`n    transition: background-color 0.5s ease, color 0.5s ease;$3'
$content = $content -replace '(body \{[^}]*)(cursor: none;)([^}]*\})', '$1$2`n    transition: background-color 0.5s ease, color 0.5s ease;$3'

# 2. Agregar transición al navbar y dark mode navbar
$content = $content -replace '(\.navbar \{[^}]*)(box-shadow: var\(--shadow-sm\);)([^}]*\})', '$1$2`n    transition: background 0.5s ease, border-bottom 0.5s ease;$3`n`n[data-theme="dark"] .navbar {`n    background: rgba(15, 23, 42, 0.95);`n    border-bottom: 1px solid rgba(255, 255, 255, 0.1);`n}'

# 3. Actualizar el botón de tema (rectangular con bordes redondeados)
$oldButton = '\/\* Theme Toggle Button \*\/[^}]*\.theme-toggle \{[^}]*\}[^}]*\.theme-toggle:hover \{[^}]*\}[^}]*\.theme-toggle i \{[^}]*\}[^}]*\.theme-toggle \.moon-icon \{[^}]*\}[^}]*\.theme-toggle \.sun-icon \{[^}]*\}[^}]*\[data-theme="dark"\] \.theme-toggle \.moon-icon \{[^}]*\}[^}]*\[data-theme="dark"\] \.theme-toggle \.sun-icon \{[^}]*\}'

$newButton = @'
/* Theme Toggle Button */
.theme-toggle {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    width: 70px;
    height: 40px;
    border-radius: 25px;
    background: var(--accent-primary);
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: var(--shadow-lg);
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 1000;
    overflow: hidden;
}

.theme-toggle:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-xl);
    width: 75px;
}

.theme-toggle i {
    color: #ffffff;
    width: 20px;
    height: 20px;
    position: absolute;
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.theme-toggle .moon-icon {
    opacity: 1;
    transform: rotate(0deg) scale(1) translateX(0);
}

.theme-toggle .sun-icon {
    opacity: 0;
    transform: rotate(180deg) scale(0) translateX(20px);
}

[data-theme="dark"] .theme-toggle .moon-icon {
    opacity: 0;
    transform: rotate(-180deg) scale(0) translateX(-20px);
}

[data-theme="dark"] .theme-toggle .sun-icon {
    opacity: 1;
    transform: rotate(0deg) scale(1) translateX(0);
}
'@

$content = $content -replace $oldButton, $newButton

# Guardar cambios
Set-Content $cssFile $content -NoNewline

Write-Host "Cambios aplicados exitosamente!"
