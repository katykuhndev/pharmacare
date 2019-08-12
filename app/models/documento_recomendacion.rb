class DocumentoRecomendacion < ApplicationRecord
  has_one_attached :receta
  belongs_to :recomendacion
  belongs_to :documento_programa
  
  def nombrar_archivo_receta
    if self.receta.attached?
      nombre_archivo = "receta_#{self.recomendacion.id_recomendacion}.#{self.receta.filename.extension}"
      self.receta.blob.update(filename: nombre_archivo)
      self.nombre = nombre_archivo
      self.save
    end
  end

end
