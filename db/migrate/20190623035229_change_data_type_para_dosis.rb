class ChangeDataTypeParaDosis < ActiveRecord::Migration[5.2]
  def self.up
    change_table :esquema_tratamientos do |t|
      t.change :dosis, :decimal, precision: 6, scale: 2
    end
  end
end
