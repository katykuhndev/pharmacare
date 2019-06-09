class CreateTratamientos < ActiveRecord::Migration[5.2]
  def change
    create_table :tratamientos do |t|
      t.references :recomendacion, foreign_key: true
      t.integer :dias
      t.integer :cantidad
      t.text :observaciones

      t.timestamps
    end
  end
end
