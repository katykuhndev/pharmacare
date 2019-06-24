class Tratamiento < ApplicationRecord
  belongs_to :recomendacion
  belongs_to :medicamento_programa
  has_many :esquema_tratamientos
end
