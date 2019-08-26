class Paciente < ApplicationRecord
  
  belongs_to :comuna, optional: true
  has_many :recomendaciones, class_name: 'Recomendacion'
  enum genero: [:femenino, :masculino]

  after_initialize :set_default_genero, :if => :new_record?

  def set_default_genero
    self.genero ||= :femenino
  end

  def name
   self.rut
  end

  def nombre_completo
    "#{self.nombres} #{self.primer_apellido} #{self.segundo_apellido}" 
  end  

  def rut_nombre_completo
    "#{self.rut} #{self.nombres} #{self.primer_apellido} #{self.segundo_apellido}" 
  end  

  def rut_nombres
    "#{self.rut} #{self.nombres}" 
  end 

  def iniciales
    "#{self.nombres[0]}#{self.primer_apellido[0]}#{self.segundo_apellido[0]}"
  end
	
end
