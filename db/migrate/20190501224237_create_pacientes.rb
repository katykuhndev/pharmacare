class CreatePacientes < ActiveRecord::Migration[5.2]
  def change
    create_table :pacientes do |t|
      t.string :nombres
      t.string :primer_apellido
      t.string :segundo_apellido
      t.string :rut
      t.integer :genero
      t.datetime :fecha_nacimiento
      t.string :fono1
      t.string :fono2
      t.string :email
      t.text :direccion
      t.references :comuna, foreign_key: true

      t.timestamps
    end
  end
end
