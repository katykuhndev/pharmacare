class Paciente < ApplicationRecord
  
  belongs_to :comuna
  has_many :recomendaciones, class_name: 'Recomendacion'
  enum genero: [:femenino, :masculino]
  
  def name
   self.nombre
  end
  	
end
