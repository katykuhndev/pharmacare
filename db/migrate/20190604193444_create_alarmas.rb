class CreateAlarmas < ActiveRecord::Migration[5.2]
  def change
    create_table :alarmas do |t|
      t.references :medicion, foreign_key: true
      t.string :nombre
      t.decimal :valor_minimo, precision: 6, scale: 2
      t.decimal :valor_maximo, precision: 6, scale: 2 
      t.text :accion
      t.integer :resultado
      t.text :observaciones

      t.timestamps
    end
  end
end
