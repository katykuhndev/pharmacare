class Medicion < ApplicationRecord
  self.table_name = "mediciones"	
  has_many :alarmas
  belongs_to :programa
  belongs_to :examen
end
