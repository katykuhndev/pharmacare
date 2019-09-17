class RenameSoloUnaVezToAsociadoCaso < ActiveRecord::Migration[5.2]
  def change
  	rename_column :documento_programas, :solo_una_vez, :asociado_caso	
  end
end
