class CreateBloques < ActiveRecord::Migration[5.2]
  def change
    create_table :bloques do |t|
      t.string :nombre
      t.time :inicio
      t.time :fin
      t.text :observaciones

      t.timestamps
    end
  end
end
