#Profe ya le pude cargar la imagen 
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear Formulario, crea una ventana gráfica con título, tamaño y posición
$form = New-Object System.Windows.Forms.Form
$form.Text = "Input Form"
$form.Size = New-Object System.Drawing.Size(500,250)
$form.StartPosition = "CenterScreen"

############# Definir etiquetas, crea textos descriptivos para cada campo y los ubica en el formulario
$textLabel1 = New-Object System.Windows.Forms.Label
$textLabel1.Text = "Input 1:"
$textLabel1.Left = 20
$textLabel1.Top = 20
$textLabel1.Width = 120

$textLabel2 = New-Object System.Windows.Forms.Label
$textLabel2.Text = "Input 2:"
$textLabel2.Left = 20
$textLabel2.Top = 60
$textLabel2.Width = 120

$textLabel3 = New-Object System.Windows.Forms.Label
$textLabel3.Text = "Input 3:"
$textLabel3.Left = 20
$textLabel3.Top = 100
$textLabel3.Width = 120

############# Caja de texto 1, crea un campo donde el usuario escribirá el primer valor
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Left = 150
$textBox1.Top = 20
$textBox1.Width = 200

############# Caja de texto 2, crea un campo para el segundo valor
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Left = 150
$textBox2.Top = 60
$textBox2.Width = 200

############# Caja de texto 3, crea un campo para el tercer valor
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Left = 150
$textBox3.Top = 100
$textBox3.Width = 200

############# Valores predetrminados, define valores iniciales vacíos para las cajas de texto
$defaultValue = ""
$textBox1.Text = $defaultValue
$textBox2.Text = $defaultValue
$textBox3.Text = $defaultValue

############# OK Boton, crea un botón que el usuario va a presionar para enviar los datos
$button = New-Object System.Windows.Forms.Button
$button.Left = 360
$button.Top = 140
$button.Width = 100
$button.Text = "OK"

############# Evento al hacer clic en el botón, guarda el contenido de las 3 cajas y cierra el formulario
$button.Add_Click({
    $form.Tag = @{
        Box1 = $textBox1.Text
        Box2 = $textBox2.Text
        Box3 = $textBox3.Text
    }
    $form.Close()
})

############# Agregar controles, añade todos los elementos botón, etiquetas y cajas a la ventana
$form.Controls.Add($button)
$form.Controls.Add($textLabel1)
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

############# Mostrar ventana, muestra el formulario en pantalla y espera la interacción del usuario
$form.ShowDialog() | Out-Null

############# Devolver valores, devuelve lo que el usuario escribió en las 3 cajas de texto.
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3