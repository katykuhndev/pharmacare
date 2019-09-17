class AddSoloUnaVezToDocumentoPrograma < ActiveRecord::Migration[5.2]
  def change
  	add_column :documento_programas, :solo_una_vez, :boolean, default: "0"
  end
end
