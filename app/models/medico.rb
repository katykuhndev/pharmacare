class Medico < ApplicationRecord
  belongs_to :comuna,  optional: true
  has_many :recomendaciones, class_name: 'Recomendacion'

  enum genero: [:femenino, :masculino]

  def name
   self.nombre_completo
  end

  def nombre_completo
   "#{self.nombres} #{self.primer_apellido} #{self.segundo_apellido}" 
  end

  	
end
