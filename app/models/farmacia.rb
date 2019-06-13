class Farmacia < ApplicationRecord
  belongs_to :comuna
  has_many :recomendaciones, class_name: 'Recomendacion'

  def name
   self.nombre
  end
end
