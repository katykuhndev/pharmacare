class DocumentoCaso < ApplicationRecord
  has_one_attached :consentimiento_informado
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

end
