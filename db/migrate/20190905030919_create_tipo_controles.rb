class CreateTipoControles < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_controles do |t|
      t.string :nombre
      t.integer :dias

      t.timestamps
    end
  end
end
