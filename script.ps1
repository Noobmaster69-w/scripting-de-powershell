function Start-ProgressBar { #Crea una función llamada Start-ProgressBar
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Title,
        
        [Parameter(Mandatory = $true)]
        [int]$Timer
    ) #Aqui se reciben los parametros: Title: texto que mostrará el progreso y Timer: cantidad de segundos que durará
    
    for ($i = 1; $i -le $Timer; $i++) { #Hace un loop desde 1 hasta el número de segundos indicado 
        Start-Sleep -Seconds 1 #Espera 1 segundo en cada iteración y simula el tiempo pasando
        $percentComplete = ($i / $Timer) * 100 #Calcula qué porcentaje ha pasado
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete #Muestra la barra en la terminal
    }
} 

# Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30 #Ejecuta la función mostrando una barra de progreso durante 30 segundos.
