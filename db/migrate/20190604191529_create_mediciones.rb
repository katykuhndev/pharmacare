class CreateMediciones < ActiveRecord::Migration[5.2]
  def change
    create_table :mediciones do |t|
      t.string :nombre
      t.text :descripcion
      t.references :programa, foreign_key: true
      t.references :examen, foreign_key: true
      t.string :unidad_medida

      t.timestamps
    end
  end
end
