class CreateRegiones < ActiveRecord::Migration[5.2]
  def change
    create_table :regiones do |t|
      t.string :nombre
      t.string :codigo
      t.timestamps null: false
    end
  end
end
