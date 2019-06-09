class EsquemaTratamiento < ApplicationRecord
  belongs_to :recomendacion
  belongs_to :tratamiento
  belongs_to :bloque
end
