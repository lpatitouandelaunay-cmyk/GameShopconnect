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

:: === LANCEMENT DU SCRIPT DE PLEIN ÉCRAN ===
set "fullscreenScript=%TEMP%\fullscreen_launcher.bat"
echo wait > "%TEMP%\gameshop_control.txt"
echo 📥 Téléchargement du lanceur plein écran...
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/lpatitouandelaunay-cmyk/GameShop/main/fullscreen_launcher.bat' -OutFile '%fullscreenScript%'"
start "" "%fullscreenScript%"

:: === DÉFINITION DES CHEMINS ===
set "zipFile=%destination%\GameShopV3.1.zip"
set "tempFolder=%destination%\GameShopV3.1"
set "sourceGameShop=%tempFolder%\GameShop"
set "targetGameShop=%destination%\GameShop"
set "renamedFolder=%destination%\GameShopV3.1"
set "configFolder=%renamedFolder%\configurationpage\data"
set "sourceJson=%USERPROFILE%\Desktop\GameShopV3.2\configurationpage\data\save_GameShop.json"

:: === AFFICHAGE DES LIENS PROMOTIONNELS ===
echo.
echo 🔗 Visite ces pages pendant l'installation :
echo - https://github.com/lpatitouandelaunay-cmyk/GameShop
echo - https://llth0y.mimo.run/index.html
echo.

start https://github.com/lpatitouandelaunay-cmyk/GameShop
start https://llth0y.mimo.run/index.html

:: === AJOUT DES LIENS DANS LES FAVORIS (Internet Explorer uniquement) ===
set "favorites=%USERPROFILE%\Favorites"
echo [InternetShortcut] > "%favorites%\GameShop.url"
echo URL=https://github.com/lpatitouandelaunay-cmyk/GameShop >> "%favorites%\GameShop.url"
echo [InternetShortcut] > "%favorites%\Mimo.url"
echo URL=https://llth0y.mimo.run/index.html >> "%favorites%\Mimo.url"

:: === TÉLÉCHARGEMENT DU FICHIER ZIP ===
echo 🌐 Téléchargement de GameShopV3.1.zip...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/lpatitouandelaunay-cmyk/GameShop/raw/refs/heads/main/GameShopV3.1.zip' -OutFile '%zipFile%'"

if not exist "%zipFile%" (
    echo ❌ Le fichier ZIP n'a pas été téléchargé.
    echo stop > "%TEMP%\gameshop_control.txt"
    pause
    exit /b
)

:: === DÉCOMPRESSION ===
echo 📦 Décompression de l'archive...
powershell -Command "Expand-Archive -Path '%zipFile%' -DestinationPath '%tempFolder%' -Force"

:: === COPIE DU DOSSIER GAMESHOP ===
xcopy "%sourceGameShop%" "%targetGameShop%" /E /I /Y
rmdir /S /Q "%tempFolder%"
rename "%targetGameShop%" "GameShopV3.1"
mkdir "%configFolder%"
copy "%sourceJson%" "%configFolder%\"
del /Q "%zipFile%"

:: === ARRÊT DU SCRIPT DE PLEIN ÉCRAN ===
echo stop > "%TEMP%\gameshop_control.txt"

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
