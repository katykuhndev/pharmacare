class MedicionRecomendacion < ApplicationRecord
  belongs_to :recomendacion
  belongs_to :medicion
end
