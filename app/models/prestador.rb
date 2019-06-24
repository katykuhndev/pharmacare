class Prestador < ApplicationRecord
  belongs_to :comuna, optional: true
  has_many :recomendaciones, class_name: 'Recomendacion'

  def name
   self.nombre
  end
end
