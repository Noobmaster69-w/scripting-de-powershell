# script3.ps1
function New-FolderCreation { #Crea una carpeta y devuelve la ruta completa de esa carpeta
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$foldername
    )

    # Crear ruta absoluta para la carpeta relativa a la ubicación actual, une el directorio actual con el nombre de la carpeta
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername
    if (-not (Test-Path -Path $logpath)) {
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null 
    }# Si la carpeta no existe, la crea

    return $logpath
    #Retorna la ruta absoluta
}
function Write-Log { #Crear archivos de log y permite escribir mensajes dentro de un log
    [CmdletBinding()]
    param(
        # Crear conjunto de parámetros, cuando queremos crear archivos
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [Alias('Names')]
        [object]$Name,                    # puede ser una sola cadena o un arreglo, $Name puede ser uno o varios nombres

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext,

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder,

        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create,

        # Conjunto de parámetros para mensaje, define los parámetros que se usan cuando la función está en modo mensaje
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message, #Se usa en el modo "Message", es el texto que se va aguardar en el log

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path, #Es la ruta del archivo donde se va a escribir

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information', #para dar colores a la etiqueta

        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG #Activa el modo mensaje dentro de la función
    )

    switch ($PsCmdlet.ParameterSetName) {
        "Create" { #Todo el bloque que mostraste define los parámetros que activan el modo "Message", detecta qué modo fue invocado
            $created = @()

            # Normalizar $Name a un arreglo, convierte un solo nombre en lista para poder iterar
            $namesArray = @() #Esta variable contendrá los nombres
            if ($null -ne $Name) { #Si $Name está vacío, no hace nada más
                if ($Name -is [System.Array]) { $namesArray = $Name } #Si $Name ya viene como lista se guarda tal cual
                else { $namesArray = @($Name) } #Si $Name es un valor simple lo mete dentro de un arreglo para poder iterar después
            }

            # Formato de fecha y hora (seguro para nombres de archivos)
            $date1 = (Get-Date -Format "yyyy-MM-dd") #Obtiene la fecha actual y la guarda en $date1 
            $time  = (Get-Date -Format "HH-mm-ss") #Obtiene la hora actual y la guarda en $time 

            # Asegurar que la carpeta exista y obtener la ruta absoluta de la carpeta,se asegura que la carpeta esté creada y guarda su ruta completa
            $folderPath = New-FolderCreation -foldername $folder

            foreach ($n in $namesArray) { #Recorre cada nombre en la lista de nombres que recibió la función
                # sanitizar nombre a cadena, asegura que cada nombre esté en formato string
                $baseName = [string]$n

                # construir nombre del archivo, 
                $fileName = "${baseName}_${date1}_${time}.$Ext"

                # ruta completa del archivo, construye la rura completa
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName

                # crear el archivo (New-Item -Force lo crea o sobrescribe; usar -ErrorAction Stop para capturar errores)
                try {
                    # Si prefieres NO sobrescribir archivos existentes, usar: if (-not (Test-Path $fullPath)) { New-Item ... }
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null

                    #  Opcional: escribir una línea de encabezado (descomentar si se desea)
                    #  "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append
                    $created += $fullPath #Va agregando todos los archivos creados a un arreglo
                }
                catch {
                    Write-Warning "Failed to create file '$fullPath' - $_" #Muestra una advertencia si algo salió mal
                }
            }

            return $created #Devuelve la lista de archivos creados
        }

        "Message" {
            # Asegurar que el directorio para el archivo de mensajes exista
            #Obtiene la carpeta donde se guardará el archivo y si no existe, la crea, evitando errores al escribir
            $parent = Split-Path -Path $path -Parent
            if ($parent -and -not (Test-Path -Path $parent)) {
                New-Item -Path $parent -ItemType Directory -Force | Out-Null
            }

            $date = Get-Date #Fecha y hora un mensaje y nivel 
            $concatmessage = "|$date| |$message| |$Severity|"

            switch ($Severity) { #Muestra los mensajes de diferentes colores, dependiendo del tipo
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

            #  Añadir el mensaje al archivo indicado (crea el archivo si no existe)
            Add-Content -Path $path -Value $concatmessage -Force #Guarda del mensaje en el archivo y guarda el log

            return $path #Devuelve dónde se guardó el log
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)" #Por defecto, lanza un error: "Conjunto de parámetros desconocido: "
        }
    }
}

# ---------- Ejemplo ----------
# Esto creará la carpeta "logs" (si no existe) y creará un archivo: Name-Log_YYYY-MM-DD_HH-mm-ss.log
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create
$logPaths