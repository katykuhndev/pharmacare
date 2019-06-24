class CreateBloquesProgramasJoinTable < ActiveRecord::Migration[5.2]
  def change
  	create_join_table :bloques, :programas
  end
end
