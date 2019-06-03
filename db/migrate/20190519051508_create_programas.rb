class CreateProgramas < ActiveRecord::Migration[5.2]
  def change
    create_table :programas do |t|
      t.references :laboratorio, foreign_key: true
      t.string :nombre
      t.text :descripcion
      t.datetime :fecha_creacion
      t.bigint :qf_soporte_id
      t.index ["qf_soporte_id"], name: "index_programas_on_qf_soporte_id"
      t.timestamps
    end
  end
end
