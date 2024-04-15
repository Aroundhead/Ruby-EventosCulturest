require 'tk'
require 'json'
require 'csv'
require 'fileutils'
require 'builder'

# Lista para almacenar los asistentes registrados
$asistentes = []

def guardar_asistente(expediente)
  correo = "a#{expediente}@unison.mx"
  # Añade el asistente a la lista global
  $asistentes << { expediente: expediente, correo: correo }
  File.open('registro_asistentes.txt', 'a') do |file|
    file.puts "Expediente: #{expediente}, Correo: #{correo}"
  end
end

def guardar_archivo(data, default_filename, format)
  options = {
    'defaultextension' => format,
    'filetypes'        => [[format.upcase, format]],
    'initialfile'      => default_filename,
    'title'            => "Guardar como"
  }
  Tk.getSaveFile(options)
end
def exportar_csv
  return if $asistentes.empty?
  filename = guardar_archivo($asistentes, 'participantes.csv', '.csv')
  return if filename.nil? || filename.empty?

  CSV.open(filename, "w") do |csv|
    $asistentes.each do |asistente|
      csv << [asistente[:expediente], asistente[:correo]]
    end
  end
end

def exportar_json
  return if $asistentes.empty?
  filename = guardar_archivo($asistentes, 'participantes.json', '.json')
  return if filename.nil? || filename.empty?

  File.write(filename, JSON.pretty_generate($asistentes))
end

def exportar_sql
  return if $asistentes.empty?
  filename = guardar_archivo($asistentes, 'participantes.sql', '.sql')
  return if filename.nil? || filename.empty?

  sql_commands = "CREATE DATABASE IF NOT EXISTS evento;\nUSE evento;\nCREATE TABLE IF NOT EXISTS asistentes (expediente VARCHAR(100), correo VARCHAR(255));\n"
  $asistentes.each do |asistente|
    sql_commands += "INSERT INTO asistentes (expediente, correo) VALUES ('#{asistente[:expediente]}', '#{asistente[:correo]}');\n"
  end
  File.write(filename, sql_commands)
end

def exportar_xml
  return if $asistentes.empty?
  filename = guardar_archivo($asistentes, 'participantes.xml', '.xml')
  return if filename.nil? || filename.empty?

  builder = Builder::XmlMarkup.new(indent: 2)
  builder.instruct!
  xml = builder.asistentes do |b|
    $asistentes.each do |asistente|
      b.asistente do
        b.expediente asistente[:expediente]
        b.correo asistente[:correo]
      end
    end
  end
  File.write(filename, xml)
end
# Define la ventana de registro de asistentes
def ventana_registro
  registro_ventana = TkToplevel.new { title "Registro de Asistente" }
  registro_ventana.minsize(300, 200)

  TkLabel.new(registro_ventana) { text 'Número de Expediente:' }.pack
  expediente_entry = TkEntry.new(registro_ventana).pack

  TkButton.new(registro_ventana) {
    text 'Registrar'
    command {
      expediente = expediente_entry.get
      guardar_asistente(expediente)
      expediente_entry.delete(0, 'end')
    }
  }.pack
end

# Ventana principal con diseño mejorado
root = TkRoot.new { title "Eventos Culturest - Gestión de Asistentes" }
root.minsize(400, 600)

# Añadiendo un logo
logo = TkPhotoImage.new(file: 'Escudo_Unison.png')  # Asegúrate de que el archivo está en la ubicación correcta
TkLabel.new(root) { image logo }.pack(pady: 10)

# Añadiendo etiquetas con estilos
TkLabel.new(root) {
  text 'EVENTOS CULTUREST'
  font TkFont.new('Helvetica 16 bold')
}.pack(pady: 5)

TkLabel.new(root) {
  text 'REGISTRO AL EVENTO'
  font TkFont.new('Helvetica 12 bold')
}.pack(pady: 5)

TkLabel.new(root) {
  text 'INGRESAR DATOS'
  font TkFont.new('Helvetica 12 italic')
}.pack(pady: 5)

TkButton.new(root) {
  text 'Registrar Nuevo Asistente'
  command { ventana_registro }
}.pack(pady: 10)

# Botones para exportar los datos de los asistentes
TkButton.new(root) {
  text 'Exportar a CSV'
  command { exportar_csv }
}.pack(pady: 5)

TkButton.new(root) {
  text 'Exportar a JSON'
  command { exportar_json }
}.pack(pady: 5)

TkButton.new(root) {
  text 'Exportar a SQL'
  command { exportar_sql }
}.pack(pady: 5)

TkButton.new(root) {
  text 'Exportar a XML'
  command { exportar_xml }
}.pack(pady: 5)

Tk.mainloop
