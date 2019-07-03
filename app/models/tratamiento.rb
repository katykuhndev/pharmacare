class Tratamiento < ApplicationRecord
  belongs_to :recomendacion
  belongs_to :medicamento_programa
  belongs_to :documento_recomendacion, optional: true
  has_many :esquema_tratamientos
end
