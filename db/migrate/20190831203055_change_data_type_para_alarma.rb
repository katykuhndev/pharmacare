class ChangeDataTypeParaAlarma < ActiveRecord::Migration[5.2]
  def self.up
    change_table :alarmas do |t|
      t.change :valor_maximo, :decimal, precision: 10, scale: 2
    end
  end
end
