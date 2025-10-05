@echo off
setlocal
chcp 65001 >nul
title GameShop - Installation V3.2
color 0A

echo ===========================================================
echo              🕹️  GameShop - Installation V3.2
echo ===========================================================
echo.

:: === Dossier d'installation forcé sur le Bureau ===
set "destination=%USERPROFILE%\Desktop"
set "installFolder=%destination%\GameShopV3.2"
mkdir "%installFolder%"
cd /d "%installFolder%"
echo 📁 Dossier d'installation : %installFolder%
echo.

:: === Vérification des fichiers de clé ===
set "keyFile=%installFolder%\key.txt"
set "hashFile=%installFolder%\expected_hash.txt"

if not exist "%keyFile%" (
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Le fichier key.txt est introuvable. L''installation continue sans vérification.','Clé manquante')"
)
if not exist "%hashFile%" (
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Le fichier expected_hash.txt est introuvable. L''installation continue sans vérification.','Hash manquant')"
)

:: === Téléchargement et ouverture de GameShopIMPORTANT.html ===
set "htmlURL=https://github.com/user-attachments/files/22704448/GameShopIMPORTANT.html"
set "htmlFile=%installFolder%\cache\GameShopIMPORTANT.html"
mkdir "%installFolder%\cache"
echo 📥 Téléchargement de GameShopIMPORTANT.html...
powershell -Command "Invoke-WebRequest -Uri '%htmlURL%' -OutFile '%htmlFile%'"
if exist "%htmlFile%" (
    echo ✅ Fichier HTML téléchargé
    start "" "%htmlFile%"
) else (
    echo ❌ Échec du téléchargement de GameShopIMPORTANT.html
)

:: === Téléchargement et installation des ZIP ===
set "zipTemp=%installFolder%\temp_zips"
mkdir "%zipTemp%"
set "baseURL=https://raw.githubusercontent.com/lpatitouandelaunay-cmyk/V3.2/main/"
set "zipList=GameShopV3.2_1.zip GameShopV3.2_2.zip GameShopV3.2_3.zip"

for %%F in (%zipList%) do (
    echo 📥 Téléchargement de %%F...
    powershell -Command "Invoke-WebRequest -Uri '%baseURL%%%F' -OutFile '%zipTemp%\%%F'"

    if exist "%zipTemp%\%%F" (
        echo 📦 Décompression de %%F...
        powershell -Command "Expand-Archive -Path '%zipTemp%\%%F' -DestinationPath '%zipTemp%\unzipped_%%~nF' -Force"

        for /d %%D in ("%zipTemp%\unzipped_%%~nF\*") do (
            echo 📁 Copie du dossier %%~nxD vers GameShopV3.2...
            xcopy "%%D" "%installFolder%\" /E /I /Y
            goto :skiprest
        )
        :skiprest

        del /Q "%zipTemp%\%%F"
    ) else (
        echo ❌ Le fichier %%F n'a pas été trouvé ou téléchargé.
    )
)

:: === Nettoyage ===
rmdir /S /Q "%zipTemp%"

:: === Message final ===
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Installation terminée ! GameShop V3.2 est prêt à être utilisé.','Installation réussie')"

echo.
pause
exit
