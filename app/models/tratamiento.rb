class Tratamiento < ApplicationRecord

	belongs_to :recomendacion
	belongs_to :medicamento_programa
	belongs_to :esquema_horario
	belongs_to :documento_recomendacion, optional: true
	has_many :esquema_tratamientos

	attr_accessor :bloques

	def posologias
		medicamento_programa = self.medicamento_programa 
       	dosis_medicamento = medicamento_programa.dosis
       	un_medicamento = medicamento_programa.unidad_medida
		texto_tratamiento = ''
		dosis_diaria = 0
		esquema = ''
    	esquema_fraccional = ''
    	esquema_completo = ''
       	self.esquema_tratamientos.each do |esquema_tratamiento|
	        bloque = esquema_tratamiento.bloque.nombre
	        dosis_bloque = esquema_tratamiento.dosis
	        dosis_fraccional = (dosis_bloque%1 != 0.0 ? ("#{(dosis_bloque.floor == 0 ? '' : dosis_bloque.floor)} #{Rational(dosis_bloque%1)}") :  dosis_bloque.floor) 
	        dosis_diaria += dosis_bloque
	        esquema = "#{esquema} #{dosis_bloque.to_s} - "
	        esquema_fraccional = "#{esquema_fraccional} #{dosis_fraccional.to_s} - "
	        esquema_completo = "#{esquema_completo} #{bloque} #{dosis_bloque.to_s} - "
    	end	
    	esquema = esquema.chomp('- ')
    	esquema_fraccional = esquema_fraccional.chomp('- ')
    	texto_tratamiento = "#{texto_tratamiento} Paciente tomará #{dosis_diaria} 
comprimidos diarios de #{dosis_medicamento} #{un_medicamento}. (#{dosis_medicamento*dosis_diaria} #{un_medicamento}  por día), durante #{self.dias} días."
	    esquema_completo = esquema_completo.chomp('- ')
	    return esquema, esquema_fraccional, texto_tratamiento, esquema_completo
	end

end
