class Region < ApplicationRecord
  
  has_many :comunas

  def name
    self.nombre
  end

end
