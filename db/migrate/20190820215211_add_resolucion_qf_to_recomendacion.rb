class AddResolucionQfToRecomendacion < ActiveRecord::Migration[5.2]
  def change
  	add_column :recomendaciones, :resolucion_qf, :integer
  end
end
