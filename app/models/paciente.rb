class Paciente < ApplicationRecord
  belongs_to :comuna

  enum genero: [:femenino, :masculino]

  def name
   self.nombre
  end
  	
end
