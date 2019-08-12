class AddEsquemaHoraraioIdToBloque < ActiveRecord::Migration[5.2]
  def change
  	add_reference :bloques, :esquema_horario, foreign_key: true
  end
end
