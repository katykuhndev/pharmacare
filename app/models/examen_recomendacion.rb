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

  def vencida?
    dias_vencimiento= self.examen_programa.dias_vencimiento
    if self.fecha_vencimiento
      diferencia_dias = (self.fecha_vencimiento.to_date - self.fecha.to_date).to_i + 1 
      if self.recomendacion.cerrada?
        return diferencia_dias > dias_vencimiento
      else
        return self.fecha_vencimiento < Time.now
      end
    else
      return false
    end    
  end 

end
