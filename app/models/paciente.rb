class Paciente < ApplicationRecord
  
  belongs_to :comuna, optional: true
  has_many :recomendaciones, class_name: 'Recomendacion'
  enum genero: [:femenino, :masculino]

  after_initialize :set_default_genero, :if => :new_record?

  def set_default_genero
    self.genero ||= :femenino
  end

  def name
   self.nombre
  end
  	
end
