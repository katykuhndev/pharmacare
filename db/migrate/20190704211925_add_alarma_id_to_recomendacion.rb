class AddAlarmaIdToRecomendacion < ActiveRecord::Migration[5.2]
  def change
  	add_reference :recomendaciones, :alarma, foreign_key: true
  end
end
