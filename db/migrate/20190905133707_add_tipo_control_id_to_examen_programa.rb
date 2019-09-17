class AddTipoControlIdToExamenPrograma < ActiveRecord::Migration[5.2]
  def change
  	add_reference :examen_programas, :tipo_control, foreign_key: true
  end
end
