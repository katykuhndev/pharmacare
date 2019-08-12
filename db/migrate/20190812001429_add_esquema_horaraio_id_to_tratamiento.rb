class AddEsquemaHoraraioIdToTratamiento < ActiveRecord::Migration[5.2]
  def change
  	add_reference :tratamientos, :esquema_horario, foreign_key: true
  end
end
