class Programa < ApplicationRecord
  belongs_to :laboratorio
  belongs_to :qf_soporte, :foreign_key => :qf_soporte_id, class_name: 'User'
  has_many :documento_programas
  has_many :medicamento_programas
  has_many :examen_programas
  has_many :mediciones, class_name: 'Medicion'
  has_and_belongs_to_many :bloques

  def inicial
    self.nombre[0]
  end

end
