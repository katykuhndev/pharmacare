class CreatePrestadores < ActiveRecord::Migration[5.2]
  def change
    create_table :prestadores do |t|
      t.string :nombre
      t.string :contacto
      t.string :fono
      t.text :direccion
      t.references :comuna, foreign_key: true

      t.timestamps
    end
  end
end
