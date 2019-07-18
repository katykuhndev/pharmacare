class AddColorToAlarma < ActiveRecord::Migration[5.2]
  def self.up
  	add_column :alarmas, :color, :string
  end
end
