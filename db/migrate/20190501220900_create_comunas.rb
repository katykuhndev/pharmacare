class CreateComunas < ActiveRecord::Migration[5.2]
  def change
    create_table :comunas do |t|
      t.string :nombre
      t.references :region, foreign_key: true

      t.timestamps null: false
    end
  end
end
