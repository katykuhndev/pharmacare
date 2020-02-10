class DocumentoCaso < ApplicationRecord
  has_one_attached :consentimiento_informado
  has_one_attached :certificado_permanencia
  has_one_attached :otro
  belongs_to :caso
  belongs_to :documento_programa

  def nombrar_archivo_consentimiento_informado
    if self.consentimiento_informado.attached?
      nombre_archivo = "consentimiento_informado_#{self.caso.codigo}.#{self.consentimiento_informado.filename.extension}"
      self.consentimiento_informado.blob.update(filename: nombre_archivo)
      self.nombre = nombre_archivo
      self.save
    end
  end

  def nombrar_archivo_certificado_permanencia
    if self.certificado_permanencia.attached?
      nombre_archivo = "certificado_permanencia_#{self.caso.codigo}.#{self.certificado_permanencia.filename.extension}"
      self.certificado_permanencia.blob.update(filename: nombre_archivo)
      self.nombre = nombre_archivo
      self.save
    end
  end

    def nombrar_archivo_otro_documento
    if self.otro_documento.attached?
      nombre_archivo = "otro_documento_#{self.caso.codigo}.#{self.otro_documento.filename.extension}"
      self.otro_documento.blob.update(filename: nombre_archivo)
      self.nombre = nombre_archivo
      self.save
    end
  end

end
