class AddDocumentoRecomendacionIdToTratamiento < ActiveRecord::Migration[5.2]
  def change
  	add_column :tratamientos, :documento_recomendacion_id, :integer
  end
end
