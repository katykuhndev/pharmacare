class ChangeDataTypeParaMedicionRecomendacion < ActiveRecord::Migration[5.2]
  def self.up
    change_table :medicion_recomendaciones do |t|
      t.change :valor, :decimal, precision: 6, scale: 2
    end
  end
end
