class CreateDocumentoProgramas < ActiveRecord::Migration[5.2]
  def change
    create_table :documento_programas do |t|
      t.string :nombre
      t.text :descripcion
      t.references :programa, foreign_key: true
      t.integer :dias_vencimiento

      t.timestamps
    end
  end
end
