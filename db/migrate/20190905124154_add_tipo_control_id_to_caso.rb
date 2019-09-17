class AddTipoControlIdToCaso < ActiveRecord::Migration[5.2]
  def change
  	add_reference :casos, :tipo_control, foreign_key: true
  end
end
