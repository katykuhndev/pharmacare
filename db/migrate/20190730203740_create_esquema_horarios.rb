class CreateEsquemaHorarios < ActiveRecord::Migration[5.2]
  def change
    create_table :esquema_horarios do |t|
      t.string :nombre
      t.text :observaciones

      t.timestamps
    end
  end
end
