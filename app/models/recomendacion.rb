class Recomendacion < ApplicationRecord
  belongs_to :caso
  belongs_to :programa
  belongs_to :paciente
  belongs_to :medico
  belongs_to :prestador
  belongs_to :farmacia
end
