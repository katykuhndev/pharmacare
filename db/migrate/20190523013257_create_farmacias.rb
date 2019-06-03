class CreateFarmacias < ActiveRecord::Migration[5.2]
  def change
    create_table :farmacias do |t|
      t.string :nombre
      t.string :contacto
      t.string :fono
      t.text :direccion
      t.references :comuna, foreign_key: true
      t.integer :tipo

      t.timestamps
    end
  end
end
