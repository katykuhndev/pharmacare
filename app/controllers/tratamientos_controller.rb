class TratamientosController < ApplicationController
  before_action :set_recomendacion
  before_action :set_tratamiento, only: [:show, :edit, :update, :destroy]

  # GET recomendacions/1/Tratamientos
  def index
    @tratamientos = @recomendacion.tratamientos
  end

  # GET recomendacions/1/Tratamientos/1
  def show	
    
  end

  # GET recomendacions/1/Tratamientos/new
  def new
    @tratamiento = @recomendacion.tratamientos.build
  end

  # GET recomendacions/1/Tratamientos/1/edit
  def edit
    @presentaciones = @recomendacion.programa.medicamento_programas
    @esquema_horario = @tratamiento.esquema_horario
    @medicamento_programa = @tratamiento.medicamento_programa
    @esquema_tratamientos = @tratamiento.esquema_tratamientos
      for esquema in @esquema_tratamientos
          case esquema.bloque.nombre
          when 'dia'
            @dia = esquema.dosis
          when 'tarde'
            @tarde = esquema.dosis
          when 'noche'
            @noche = esquema.dosis
          when 'am'
            @am = esquema.dosis
          when 'pm'
            @pm = esquema.dosis
          when 'dia_entero'
            @dia_entero = esquema.dosis
          end
      end   
  end

  # POST recomendacions/1/Tratamientos
  def create
    @tratamiento = @recomendacion.tratamientos.build(tratamiento_params)

    if @tratamiento.save
      redirect_to([@tratamiento.recomendacion, @tratamiento], notice: 'tratamiento was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT recomendacions/1/Tratamientos/1
  def update
    @esquema_tratamientos = @tratamiento.esquema_tratamientos
    if @tratamiento.esquema_horario_id != tratamiento_params["esquema_horario_id"]
      @esquema_tratamientos.destroy_all
      @bloques = @recomendacion.programa.bloques.where({ esquema_horario_id: tratamiento_params["esquema_horario_id"] } )
      for bloque in @bloques
        EsquemaTratamiento.create(recomendacion_id: @recomendacion.id, tratamiento_id: @tratamiento.id, bloque_id: bloque.id, dosis: tratamiento_params["bloques"]["#{bloque.nombre}"]) if tratamiento_params["bloques"]["#{bloque.nombre}"].to_i > 0
      end 
    else
      for esquema in @esquema_tratamientos
        case esquema.bloque.nombre
        when 'dia'
          esquema.update(dosis: tratamiento_params["bloques"]["dia"])
        when 'tarde'
          esquema.update(dosis: tratamiento_params["bloques"]["tarde"])   
        when 'noche'
          esquema.update(dosis: tratamiento_params["bloques"]["noche"])
        when 'am'
          esquema.update(dosis: tratamiento_params["bloques"]["am"])
        when 'pm'
          esquema.update(dosis: tratamiento_params["bloques"]["pm"])   
        when 'dia_entero'
          esquema.update(dosis: tratamiento_params["bloques"]["dia_entero"])  
        end    
      end  
    end

    if @tratamiento.update_attributes(tratamiento_params)
      redirect_to([@tratamiento.recomendacion, @tratamiento], notice: 'Tratamiento se actualizó correctamente.')
    else
      render action: 'edit'
    end
  end

  # DELETE recomendacions/1/Tratamientos/1
  def destroy
    @tratamiento.esquema_tratamientos.destroy_all
    @tratamiento.destroy

    redirect_to recomendacion_url(@recomendacion)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recomendacion
      @recomendacion = Recomendacion.find(params[:recomendacion_id])
    end

    def set_tratamiento
      @tratamiento = @recomendacion.tratamientos.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tratamiento_params
      params.require(:tratamiento).permit(:recomendacion , :esquema_horario_id, {bloques: [:dia, :tarde, :noche, :am, :pm, :dia_entero]}, :dias , :cantidad , :observaciones , :medicamento_programa_id , :documento_recomendacion_id)
    end
end
