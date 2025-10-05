@echo off
setlocal

:: === CHOIX DU DOSSIER D'INSTALLATION ===
echo Où veux-tu installer GameShop ?
echo 1 - Documents
echo 2 - Bureau
echo 3 - Autre emplacement (copie-colle le chemin)
set /p choix="Tape 1, 2 ou 3 puis Entrée : "

if "%choix%"=="1" (
    set "destination=%USERPROFILE%\Documents"
) else if "%choix%"=="2" (
    set "destination=%USERPROFILE%\Desktop"
) else if "%choix%"=="3" (
    set /p destination="Colle ici le chemin complet du dossier : "
) else (
    echo ❌ Choix invalide. Fermeture du script.
    pause
    exit /b
)

:: === TÉLÉCHARGEMENT DE GameShopIMPORTANT.html ===
set "importantFile=%destination%\GameShopIMPORTANT.html"
echo 📥 Téléchargement de GameShopIMPORTANT.html...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/user-attachments/files/22704448/GameShopIMPORTANT.html' -OutFile '%importantFile%'"

:: === OUVERTURE DU FICHIER DANS LE NAVIGATEUR ===
echo 🌐 Ouverture du fichier dans le navigateur...
start "" "%importantFile%"

:: === INSTALLATION DE GAMESHOP ===
set "zipFile=%destination%\GameShopV3.1.zip"
set "tempFolder=%destination%\GameShopV3.1"
set "sourceGameShop=%tempFolder%\GameShop"
set "targetGameShop=%destination%\GameShop"
set "renamedFolder=%destination%\GameShopV3.1"
set "configFolder=%renamedFolder%\configurationpage\data"
set "cacheFolder=%renamedFolder%\cache"
set "sourceJson=%USERPROFILE%\Desktop\GameShopV3.2\configurationpage\data\save_GameShop.json"

echo 🌐 Téléchargement de GameShopV3.1.zip...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/lpatitouandelaunay-cmyk/GameShop/raw/refs/heads/main/GameShopV3.1.zip' -OutFile '%zipFile%'"

if not exist "%zipFile%" (
    echo ❌ Le fichier ZIP n'a pas été téléchargé.
    pause
    exit /b
)

echo 📦 Décompression de GameShopV3.1.zip...
powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%tempFolder%' -Force"

echo 📁 Copie du dossier GameShop...
xcopy "%sourceGameShop%" "%targetGameShop%" /E /I /Y
rmdir /S /Q "%tempFolder%"
rename "%targetGameShop%" "GameShopV3.1"
mkdir "%configFolder%"
mkdir "%cacheFolder%"

:: === VÉRIFICATION DU FICHIER JSON ===
if exist "%sourceJson%" (
    copy "%sourceJson%" "%configFolder%\"
) else (
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Le fichier save_GameShop.json est introuvable. L''installation continue sans ce fichier.','Fichier manquant')"
)

:: === DÉPLACEMENT DU FICHIER HTML DANS LE CACHE ===
if exist "%importantFile%" (
    move /Y "%importantFile%" "%cacheFolder%\"
)

del /Q "%zipFile%"

:: === MESSAGE FINAL POPUP ===
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Installation terminée ! Pense à faire les mises à jour régulièrement sinon le jeu risque de ne plus fonctionner.','GameShop - Mise à jour recommandée')"

:: === PROPOSITION DE SUPPRESSION DE L'ANCIENNE VERSION ===
echo.
echo 🔧 Souhaites-tu libérer du stockage en supprimant l'ancienne version ?
echo 1 - Oui
echo 2 - Non
set /p choixSupp="Tape 1 ou 2 puis Entrée : "

if "%choixSupp%"=="1" (
    echo.
    echo 📌 Copie-colle le chemin du dossier à supprimer (ex: C:\Users\Nom\Documents\GameShopV3.0)
    set /p cheminASupprimer="Chemin du dossier à supprimer : "
    echo.
    echo Appuie sur Entrée pour continuer ou Échap pour annuler...
    pause >nul
    rmdir /S /Q "%cheminASupprimer%"
    echo ✅ Dossier supprimé.
) else (
    echo ❎ Suppression annulée.
)

exit
