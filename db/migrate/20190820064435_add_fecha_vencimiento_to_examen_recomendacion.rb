class AddFechaVencimientoToExamenRecomendacion < ActiveRecord::Migration[5.2]
  def self.up
  	add_column :examen_recomendaciones, :fecha_vencimiento , :date
  end
end
