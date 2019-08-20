class Recomendacion < ApplicationRecord

validate :id_recomendacion_valido, on: :create
 
#scope :historicas, -> { joins(:documento_recomendaciones).where(paciente: paciente) }

  belongs_to :caso, optional: true
  belongs_to :programa, optional: true
  belongs_to :paciente, optional: true
  belongs_to :medico, optional: true
  belongs_to :prestador, optional: true
  belongs_to :farmacia, optional: true
  belongs_to :alarma, optional: true
  belongs_to :qf_soporte, optional: true, :foreign_key => :qf_soporte_id, class_name: 'User'
  belongs_to :ejecutivo, optional: true, :foreign_key => :ejecutivo_id, class_name: 'User'
  
  attr_accessor :atributos_paciente
  attr_accessor :atributos_examen
  attr_accessor :atributos_receta
  attr_accessor :atributos_tratamiento
  attr_accessor :fecha_receta
  attr_accessor :fecha_examen
  attr_accessor :fecha_vencimiento_receta
  attr_accessor :fecha_vencimiento_examen

  has_many :tratamientos
  has_many :esquema_tratamientos
  has_many :documento_recomendaciones
  has_many :examen_recomendaciones
  has_many :medicion_recomendaciones
  

  enum estado: [:abierta, :preinforme, :cerrada]
  enum resultado: [:aprobacion, :aprobacion_con_reparos, :rechazo_administrativo, :rechazo_tecnico]
  enum via_ingreso: [:whatsapp, :email, :fono]

  after_initialize :set_default_estado, :if => :new_record?
  after_initialize :set_default_fecha_hora_ingreso, :if => :new_record?
  after_initialize :set_default_con_alarma, :if => :new_record?
  after_initialize :set_default_resultado, :if => :new_record?

scope :historicas, -> (recomendacion){ left_outer_joins(:documento_recomendaciones).left_outer_joins(:examen_recomendaciones)
  .select('recomendaciones.id, recomendaciones.resultado, recomendaciones.id_recomendacion, recomendaciones.fecha_hora_ingreso, documento_recomendaciones.id as id_receta, examen_recomendaciones.id as id_examen')
  .where("recomendaciones.paciente_id = ? ", recomendacion.paciente_id )
  .order("id")}


def id_recomendacion_valido
  if self.id_recomendacion.size != 11
    errors.add(:id_recomendacion, "Debe ser de 11 caracteres de largo")
  end
end

def get_proximo_id_recomendacion
  ultima_id_recomendacion = self.get_ultima_solicitud ? self.get_ultima_solicitud.id_recomendacion : nil
  fecha_hoy = Date.today.strftime("%d%m%Y")
  proximo_numero_string = 1.to_s.rjust(3, "0")
  proximo_id_recomendacion = proximo_numero_string + fecha_hoy
  ultima_fecha = ultima_id_recomendacion ? ultima_id_recomendacion[3..11] : nil
  if ultima_fecha == fecha_hoy
   # ya hubo casos antes en el mismo dia
    proximo_numero = ultima_id_recomendacion[0..2].sub!(/^0*/, '').to_i + 1
    proximo_numero_string = proximo_numero.to_s.rjust(3, "0")
    proximo_id_recomendacion = proximo_numero_string + fecha_hoy
  end  
  return proximo_id_recomendacion
end

  def get_ultima_solicitud
    recomendacion = Recomendacion.order("id").last
  end

  def set_default_resultado
    self.resultado ||= :aprobacion
  end

  def set_default_estado
    self.estado ||= :abierta
  end

  def set_default_con_alarma
    self.con_alarma = 0
  end

  def set_default_fecha_hora_ingreso
    self.fecha_hora_ingreso = Time.now()
  end 

  def resolucion_recomendacion
    self.resultado = :aprobacion
    self.procesar_alarma
    self.resultado = :aprobacion_con_reparos if self.get_fecha_vencimiento_receta && self.get_fecha_vencimiento_receta < Time.now
    self.resultado = :rechazo_tecnico if self.get_fecha_vencimiento_examen && self.get_fecha_vencimiento_examen < Time.now
  end 

    def procesar_alarma
    #TODO
    # cambiar medicion_id: 1 por algo mas generico
    # medicion 1 es RAN
    alarmas = Alarma.where(medicion_id: 1)
    if alarmas.count > 0 && self.medicion_recomendaciones.where(medicion_id: 1).exists?
      valor = self.medicion_recomendaciones.where(medicion_id: 1).first.valor
      for alarma in alarmas
        if valor && valor >= alarma.valor_minimo && valor <= alarma.valor_maximo
          self.resultado = alarma.resultado
          self.alarma_id = alarma.id
          self.con_alarma = 1
          return alarma
        end  
      end  
      return false  
    else
     return false 
    end
  end   

  def get_fecha_receta
    documento_receta = self.documento_recomendaciones.where(documento_programa_id: 1).first
    @fecha_receta = documento_receta ? documento_receta.fecha : false
  end

  def get_fecha_examen
    documento_examen = self.examen_recomendaciones.where(examen_programa_id: 1).first
    @fecha_examen = documento_examen ? documento_examen.fecha : false
  end  

  def get_fecha_vencimiento_receta
    documento_programa = DocumentoPrograma.find(1)
    dias_vencimiento_receta = documento_programa.dias_vencimiento 
    fecha_receta = self.get_fecha_receta
    @fecha_vencimiento_receta = fecha_receta ? (fecha_receta + dias_vencimiento_receta.days) : false
  end

  def get_fecha_vencimiento_examen
    examen_programa = ExamenPrograma.find(2)
    dias_vencimiento_examen = examen_programa.dias_vencimiento 
    fecha_examen = self.get_fecha_examen
    @fecha_vencimiento_examen = fecha_examen ? (fecha_examen + dias_vencimiento_examen.days) : false
  end 

  def informacion_completa?
    return false if self.paciente.nil?
    return false if self.medico.nil?
    return false if self.prestador.nil?
    return false if self.farmacia.nil? 
    return false if self.farmacia.nil?
    return false if self.documento_recomendaciones.empty? 
    self.documento_recomendaciones.map { |doc| return false if doc.fecha.nil? }
    return false if self.examen_recomendaciones.empty?
    self.documento_recomendaciones.map { |doc| return false if doc.fecha.nil? }
    return false if self.medicion_recomendaciones.empty?
    return false if self.tratamientos.empty?
    return false if self.esquema_tratamientos.empty?
    return true
  end

  def farmacia_nombre
    farmacia.try(:nombre)
  end

  def farmacia_nombre=(nombre)
    self.farmacia = Farmacia.find_or_create_by(nombre: nombre) if nombre.present?
  end

  def prestador_nombre
    prestador.try(:nombre)
  end

  def prestador_nombre=(nombre)
    self.prestador = Prestador.find_or_create_by(nombre: nombre) if nombre.present?
  end

  def medico_nombre
    medico.try(:nombre_completo)
  end

  def medico_nombre=(nombre)
    nombre_split =  nombre.split
    self.medico = Medico.find_or_create_by(nombres: nombre_split[0].strip, primer_apellido: nombre_split[1].strip, segundo_apellido: nombre_split[2].strip) if nombre.present?
  end

end
