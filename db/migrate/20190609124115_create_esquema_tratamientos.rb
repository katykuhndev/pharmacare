class CreateEsquemaTratamientos < ActiveRecord::Migration[5.2]
  def change
    create_table :esquema_tratamientos do |t|
      t.references :recomendacion, foreign_key: true
      t.references :tratamiento, foreign_key: true
      t.references :bloque, foreign_key: true
      t.decimal :dosis
      t.string :unidad_medida
      t.text :observaciones

      t.timestamps
    end
  end
end
