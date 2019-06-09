class CreateMedicionRecomendaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :medicion_recomendaciones do |t|
      t.references :recomendacion, foreign_key: true
      t.references :medicion, foreign_key: true
      t.decimal :valor
      t.string :unidad_medida

      t.timestamps
    end
  end
end
