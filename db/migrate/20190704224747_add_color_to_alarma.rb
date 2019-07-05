class AddColorToAlarma < ActiveRecord::Migration[5.2]
  def change
  	add_column :alarmas, :color, :string
  end
end
