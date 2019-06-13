class Recomendacion < ApplicationRecord
 
  enum estado: [:pendiente, :por_resolver, :cerrada]
 
  after_initialize :set_default_estado, :if => :new_record?
  after_initialize :set_default_fecha_hora_ingreso, :if => :new_record?

  def set_default_estado
    self.estado ||= :pendiente
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

  enum resultado: [:aprobacion, :aprobacion_con_reparos, :rechazo_administrativo, :rechazo_tecnico]
  enum via_ingreso: [:whatsapp, :email, :fono]
  
end
