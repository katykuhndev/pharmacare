class DocumentoRecomendacion < ApplicationRecord
  has_one_attached :receta
  belongs_to :recomendacion
  belongs_to :documento_programa
end
