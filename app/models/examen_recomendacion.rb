class ExamenRecomendacion < ApplicationRecord
  has_one_attached :examen	
  belongs_to :recomendacion
  belongs_to :examen_programa
end
