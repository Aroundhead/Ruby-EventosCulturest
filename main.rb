require 'tk'

def guardar_asistente(expediente, correo)
  File.open('registro_asistentes.txt', 'a') do |file|
    file.puts "Expediente: #{expediente}, Correo: #{correo}"
  end
end

root = TkRoot.new { title "Eventos Culturest - Registro al Evento" }
root.minsize(400, 600)

logo = TkPhotoImage.new(file: 'Escudo_Unison.png') # Asegúrate de que 'unison_logo.png' esté en la misma carpeta que tu script o proporciona la ruta completa
TkLabel.new(root) { image logo }.pack(pady: 10)

TkLabel.new(root) {
  text 'EVENTOS CULTUREST'
  font TkFont.new('Helvetica 16 bold')
  pack(pady: 5)
}

TkLabel.new(root) {
  text 'REGISTRO AL EVENTO'
  font TkFont.new('Helvetica 12 bold')
  pack(pady: 5)
}

TkLabel.new(root) {
  text 'INGRESAR DATOS'
  font TkFont.new('Helvetica 12 italic')
  pack(pady: 5)
}

TkLabel.new(root) {
  text 'Número de Expediente:'
  pack(pady: 5, padx: 10, side: 'top')
}

expediente_entry = TkEntry.new(root)
expediente_entry.pack(pady: 5, padx: 10, side: 'top')

TkLabel.new(root) {
  text 'Correo Electrónico:'
  pack(pady: 5, padx: 10, side: 'top')
}

correo_entry = TkEntry.new(root)
correo_entry.pack(pady: 5, padx: 10, side: 'top')

TkButton.new(root) {
  text 'Registrar'
  command {
    expediente = expediente_entry.value.strip
    correo = correo_entry.value.strip
    if expediente.empty? || correo.empty?
      Tk.messageBox(
        'type'    => 'ok',
        'icon'    => 'warning',
        'title'   => 'Validación',
        'message' => 'Todos los campos son obligatorios'
      )
    else
      guardar_asistente(expediente, correo)
      Tk.messageBox(
        'type'    => 'ok',
        'icon'    => 'info',
        'title'   => 'Registro Exitoso',
        'message' => 'Asistente registrado con éxito'
      )
      expediente_entry.value = ''
      correo_entry.value = ''
    end
  }
  pack(pady: 10, padx: 10, side: 'top')
}

Tk.mainloop
