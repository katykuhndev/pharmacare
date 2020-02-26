class InformesController < ApplicationController
  
  def index
  end

  def mostrar_listado
  	@fecha_desde = params[:fecha_desde]
  	@fecha_hasta = params[:fecha_hasta]
  	@tipo_informe = params[:tipo_informe]
  	if @tipo_informe == 'Informe Normal'
  	  @informe = Informe.informe_normal(@fecha_desde,@fecha_hasta)
    elsif @tipo_informe == 'Informe Medicos'
      @informe = Informe.informe_medicos(@fecha_desde,@fecha_hasta)
    else @tipo_informe == 'Informe Medicos Adheridos'
      medico_id = params[:medico_id]
      @medico = Medico.find(medico_id)
      @informe = Informe.informe_medico_adherido(@fecha_desde,@fecha_hasta,medico_id)  
    end
  end

end
