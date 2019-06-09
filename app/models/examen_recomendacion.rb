class ExamenRecomendacion < ApplicationRecord
  belongs_to :recomendacion
  belongs_to :examen_programa
end
