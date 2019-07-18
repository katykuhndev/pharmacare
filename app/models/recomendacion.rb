class Recomendacion < ApplicationRecord

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
  attr_accessor :fecha_receta
  attr_accessor :fecha_examen
  attr_accessor :fecha_vencimiento_receta
  attr_accessor :fecha_vencimiento_examen

  has_many :tratamientos
  has_many :esquema_tratamientos
  has_many :documento_recomendaciones
  has_many :examen_recomendaciones
  has_many :medicion_recomendaciones
  

  enum estado: [:pendiente, :por_resolver, :cerrada]
  enum resultado: [:aprobacion, :aprobacion_con_reparos, :rechazo_administrativo, :rechazo_tecnico]
  enum via_ingreso: [:whatsapp, :email, :fono]

  after_initialize :set_default_estado, :if => :new_record?
  after_initialize :set_default_fecha_hora_ingreso, :if => :new_record?
  after_initialize :set_default_con_alarma, :if => :new_record?
  after_initialize :set_default_resultado, :if => :new_record?


  def set_default_resultado
    self.resultado ||= :aprobacion
  end

  def set_default_estado
    self.estado ||= :pendiente
  end

  def set_default_con_alarma
    self.con_alarma = 0
  end

  def set_default_fecha_hora_ingreso
    self.fecha_hora_ingreso = Time.now()
  end 

  def resolucion_recomendacion
    #TODO
    # cambiar documento_programa_id: 1 por algo mas generico
    # cambiar ExamenPrograma.find(2) por algo mas generico
    self.resultado = :aprobacion
    self.procesar_alarma
    if self.informacion_completa?
      self.resultado = :aprobacion_con_reparos if self.get_fecha_vencimiento_receta < Time.now
      self.resultado = :rechazo_tecnico if self.get_fecha_vencimiento_examen < Time.now
      self.estado = :por_resolver 
    else
      return false
    end
  end 

    def procesar_alarma
    #TODO
    # cambiar medicion_id: 1 por algo mas generico
    # medicion 1 es RAN
    alarmas = Alarma.where(medicion_id: 1)
    if alarmas.count > 0 && self.medicion_recomendaciones.where(medicion_id: 1).exists?
      valor = self.medicion_recomendaciones.where(medicion_id: 1).first.valor
      puts 'holaholahilaaaaaa'
      puts valor
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

end
