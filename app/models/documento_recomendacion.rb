class DocumentoRecomendacion < ApplicationRecord
  belongs_to :recomendacion
  belongs_to :documento_programa
end
