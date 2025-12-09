###################################
# Prerequisites

# Actualiza la lista de paquetes, actualiza los repositorios para saber qué paquetes están disponibles.
sudo apt-get update

# Instala paquetes necesarios, instala herramientas necesarias como wget y soporte para HTTPS.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Obtiene la versión de Ubuntu, carga variables del sistema para saber tu versión de Ubuntu.
source /etc/os-release

# Descarga las llaves del repositorio de Microsoft, descarga el archivo .deb que permite usar repositorios de Microsoft.
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# Registra las llaves del repositorio, instala ese archivo para agregar el repositorio de Microsoft.
sudo dpkg -i packages-microsoft-prod.deb

# Borra el archivo de llaves, elimina el archivo descargado porque ya no se necesita.
rm packages-microsoft-prod.deb

# Actualizar la lista de paquetes después de que agregamos packages.microsoft.com, actualiza repositorios
sudo apt-get update

###################################
# Instala PowerShell
sudo apt-get install -y powershell

# Inicia PowerShell
pwsh
