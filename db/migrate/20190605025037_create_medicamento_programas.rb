class CreateMedicamentoProgramas < ActiveRecord::Migration[5.2]
  def change
    create_table :medicamento_programas do |t|
      t.references :programa, foreign_key: true
      t.string :nombre_comercial
      t.string :principio_activo
      t.decimal :dosis, precision: 6, scale: 2
      t.string :unidad_medida
      t.integer :cantidad

      t.timestamps
    end
  end
end
