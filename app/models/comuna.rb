class Comuna < ApplicationRecord
  
  belongs_to :region

  def name
   self.nombre
  end

end
