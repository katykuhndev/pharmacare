class CreateDocumentoRecomendaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :documento_recomendaciones do |t|
      t.string :nombre
      t.references :recomendacion, foreign_key: true
      t.references :documento_programa, foreign_key: true
      t.integer :ejecutivo_id
      t.datetime :fecha
      t.text :observaciones

      t.timestamps
    end
  end
end
