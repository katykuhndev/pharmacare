class Recomendacion < ApplicationRecord
 
  enum estado: [:pendiente, :por_resolver, :cerrada]
 
  after_initialize :set_default_estado, :if => :new_record?
  after_initialize :set_default_fecha_hora_ingreso, :if => :new_record?
  after_initialize :set_default_con_alarma, :if => :new_record?

  def set_default_estado
    self.estado ||= :pendiente
  end

  def set_default_con_alarma
    self.con_alarma = 0
  end

  def set_default_fecha_hora_ingreso
    self.fecha_hora_ingreso = Time.now()
  end

  belongs_to :caso, optional: true
  belongs_to :programa, optional: true
  belongs_to :paciente, optional: true
  belongs_to :medico, optional: true
  belongs_to :prestador, optional: true
  belongs_to :farmacia, optional: true
  belongs_to :qf_soporte, optional: true, :foreign_key => :qf_soporte_id, class_name: 'User'
  belongs_to :ejecutivo, optional: true, :foreign_key => :ejecutivo_id, class_name: 'User'
  
  attr_accessor :atributos_paciente
  attr_accessor :atributos_examen
  attr_accessor :atributos_receta

  has_many :tratamientos
  has_many :esquema_tratamientos
  has_many :documento_recomendaciones
  has_many :examen_recomendaciones
  has_many :medicion_recomendaciones

  enum resultado: [:aprobacion, :aprobacion_con_reparos, :rechazo_administrativo, :rechazo_tecnico]
  enum via_ingreso: [:whatsapp, :email, :fono]
  
end
