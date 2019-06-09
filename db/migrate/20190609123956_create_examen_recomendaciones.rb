class CreateExamenRecomendaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :examen_recomendaciones do |t|
      t.string :nombre
      t.references :recomendacion, foreign_key: true
      t.references :examen_programa, foreign_key: true
      t.integer :ejecutivo_id
      t.datetime :fecha
      t.text :observaciones

      t.timestamps
    end
  end
end
