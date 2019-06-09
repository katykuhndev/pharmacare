class CreateCasos < ActiveRecord::Migration[5.2]
  def change
    create_table :casos do |t|
      t.string :codigo
      t.references :programa, foreign_key: true
      t.references :medico, foreign_key: true
      t.references :paciente, foreign_key: true
      t.integer :qf_soporte_id
      t.integer :ejecutivo_id
      t.datetime :fecha_hora_ingreso
      t.integer :via_ingreso
      t.datetime :fecha_hora_cierre
      t.text :observaciones

      t.timestamps
    end
  end
end
