class ExamenRecomendacion < ApplicationRecord
  has_one_attached :examen	
  belongs_to :recomendacion
  belongs_to :examen_programa

  def nombrar_archivo_examen
    if self.examen.attached?
      nombre_archivo = "examen_#{self.recomendacion.id_recomendacion}.#{self.examen.filename.extension}"
      self.examen.blob.update(filename: nombre_archivo)
      self.nombre = nombre_archivo
      self.save
    end
  end

end
