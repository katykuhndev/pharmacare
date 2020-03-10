class AddMotivoRechazoToRecomendacion < ActiveRecord::Migration[5.2]
  def change
  	add_column :recomendaciones, :motivo_rechazo, :text
  end
end
