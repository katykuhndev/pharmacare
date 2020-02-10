class Paciente < ApplicationRecord
  
  belongs_to :comuna, optional: true
  has_many :recomendaciones, class_name: 'Recomendacion'
  has_many :casos, class_name: 'Caso'
  enum genero: [:femenino, :masculino]

  after_initialize :set_default_genero, :if => :new_record?

  def recomendaciones_historicas
    Recomendacion.select("recomendaciones.*, documento_recomendaciones.id as id_receta, examen_recomendaciones.id as id_examen").joins(:documento_recomendaciones).joins(:examen_recomendaciones).where(paciente_id: self.id)
  end  
 
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
