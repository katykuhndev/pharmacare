class CreateDocumentoCasos < ActiveRecord::Migration[5.2]
  def change
    create_table :documento_casos do |t|
      t.string :nombre
      t.references :caso, foreign_key: true
      t.references :documento_programa, foreign_key: true
      t.integer :ejecutivo_id
      t.datetime :fecha
      t.text :observaciones
      t.date :fecha_vencimiento

      t.timestamps
    end
  end
end
