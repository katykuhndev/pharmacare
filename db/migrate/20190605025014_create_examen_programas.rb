class CreateExamenProgramas < ActiveRecord::Migration[5.2]
  def change
    create_table :examen_programas do |t|
      t.references :examen, foreign_key: true
      t.references :programa, foreign_key: true
      t.integer :dias_vencimiento

      t.timestamps
    end
  end
end
