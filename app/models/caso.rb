class Caso < ApplicationRecord
  belongs_to :programa
  belongs_to :medico
  belongs_to :paciente
end
