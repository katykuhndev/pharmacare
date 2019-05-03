class CambiaFechaNacimientoPaciente < ActiveRecord::Migration[5.2]
	def change
	    change_column(:pacientes, :fecha_nacimiento, :date)
	end
end