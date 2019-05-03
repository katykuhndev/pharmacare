class CambiaFechaNacimientoMedico < ActiveRecord::Migration[5.2]
	def change
	    change_column(:medicos, :fecha_nacimiento, :date)
	end
end
