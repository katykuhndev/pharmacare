class AddFechaVencimientoToDocumentoRecomendacion < ActiveRecord::Migration[5.2]
  def self.up
  	add_column :documento_recomendaciones, :fecha_vencimiento , :date
  end
end
