class Caso < ApplicationRecord
  belongs_to :programa
  belongs_to :paciente
  belongs_to :medico, optional: true
  belongs_to :tipo_control

  has_many :recomendaciones
  has_many :documento_casos
  
  after_initialize :set_default_fecha_hora_ingreso, :if => :new_record?
  after_initialize :set_default_tipo_control_id, :if => :new_record?
  
  def set_default_fecha_hora_ingreso
    self.fecha_hora_ingreso = Time.now()
  end 

  def set_default_tipo_control_id
    self.tipo_control_id = 1
  end 

  def self.busca_codigo(codigo, programa_id)
  	caso = Caso.where("programa_id = ? and codigo like ? ", programa_id, "%#{codigo}%").order('codigo desc').first
    if caso
     codigo_caso = caso.codigo
     numero = codigo_caso[5..-1].to_i
     nuevo_codigo = "#{codigo_caso[0,5]}#{numero+1}"
    else
     codigo	
    end
  end

  def get_documentos_caso
  	# TODO
  	# Adaptar a generico
  	@documento_programa_caso = DocumentoPrograma.where("programa_id = ? and asociado_caso = ?", self.programa_id, 1).first
    @documento_caso = self.documento_casos.where("documento_programa_id = ?", @documento_programa_caso.id ).first
    return @documento_caso 
  end	
  	
end
