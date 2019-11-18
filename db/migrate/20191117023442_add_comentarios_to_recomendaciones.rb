class AddComentariosToRecomendaciones < ActiveRecord::Migration[5.2]
  def change
    add_column :recomendaciones, :comentarios, :text
  end
end
