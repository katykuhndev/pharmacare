class CreateRecomendaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :recomendaciones do |t|
      t.string :id_recomendacion
      t.integer :estado
      t.integer :resultado
      t.references :caso, foreign_key: true
      t.references :programa, foreign_key: true
      t.references :paciente, foreign_key: true
      t.references :medico, foreign_key: true
      t.references :prestador, foreign_key: true
      t.references :farmacia, foreign_key: true
      t.integer :qf_soporte_id
      t.integer :ejecutivo_id
      t.datetime :fecha_hora_ingreso
      t.integer :via_ingreso
      t.datetime :fecha_hora_respuesta
      t.text :observaciones
      t.boolean :con_alarma

      t.timestamps
    end
  end
end
