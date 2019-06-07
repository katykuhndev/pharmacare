class Examen < ApplicationRecord
	self.table_name = "examenes"
	has_many :examen_programas
end
