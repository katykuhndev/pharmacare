class RecomendacionesController < ApplicationController
  before_action :set_recomendacion, only: [:show, :edit, :update, :destroy]

  # GET /recomendaciones
  # GET /recomendaciones.json
  def index
    @recomendaciones = Recomendacion.all
    @query = Recomendacion.ransack(params[:q])
    @recomendaciones = @query.result.includes(:programa,:paciente,:medico,:prestador,:farmacia,:qf_soporte,:ejecutivo).page(params[:page])
  end

  # GET /recomendaciones/1
  # GET /recomendaciones/1.json
  def show
    # TODO
    # Parametrizar correctamente todo 
     @datos_paciente = @recomendacion.paciente ? "#{@recomendacion.paciente.nombres} #{@recomendacion.paciente.primer_apellido} #{@recomendacion.paciente.segundo_apellido}"  : '' 
     @datos_medico = @recomendacion.medico ? "#{@recomendacion.medico.nombres} #{@recomendacion.medico.primer_apellido} #{@recomendacion.medico.segundo_apellido}"  : '' 
     @datos_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre  : '' 
     @datos_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre  : ''
     @qf_soporte = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''
     @ejecutivo = @recomendacion.ejecutivo ? @recomendacion.ejecutivo.name : ''
     #receta
     @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
     @fecha_receta = @documento_receta ? @documento_receta.fecha : ''
     @tratamiento = @recomendacion.tratamientos.first
     @medicamento_programa = @tratamiento ? @tratamiento.medicamento_programa : ''
     @presentacion = @medicamento_programa ? @medicamento_programa.nombre_comercial : ''
     @dias = @tratamiento ? @tratamiento.dias : ''
     @cantidad = @tratamiento ?  @tratamiento.cantidad : ''
     @esquema_tratamientos = @recomendacion.esquema_tratamientos
     @dia = @esquema_tratamientos.where(bloque_id: 1).first ? @esquema_tratamientos.where(bloque_id: 1).first.dosis : ''
     @tarde = @esquema_tratamientos.where(bloque_id: 2).first ? @esquema_tratamientos.where(bloque_id: 2).first.dosis : ''
     @noche = @esquema_tratamientos.where(bloque_id: 3).first ? @esquema_tratamientos.where(bloque_id: 3).first.dosis : ''
     
     @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
     @fecha_receta = @documento_receta ? @documento_receta.fecha : ''
     
     @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
     @fecha_examen = @documento_examen ? @documento_examen.fecha : ''
     
     @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
     @leucocitos =@recomendacion.medicion_recomendaciones.where(medicion_id: 2).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 2).first.valor : ''
     @baciliformes = @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first.valor : ''
     @segmentados = @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first.valor : ''

  end

  # GET /recomendaciones/new
  def new
    # TODO
    # Agregar formulario para escoger laboratorios
    @laboratorio = Laboratorio.find(1)
    @programas = @laboratorio.programas
    @recomendacion = Recomendacion.new
    puts 'holaaaaaa'
    puts current_user.id
    @recomendacion.ejecutivo_id = current_user.id
    
  end

  # GET /recomendaciones/1/edit
  def edit
    # TODO
    # Parametrizar correctamente todo 

    @paciente = @recomendacion.paciente
    @nombres = @paciente ? @paciente.nombres : ''
    @primer_apellido = @paciente ? @paciente.primer_apellido : ''
    @segundo_apellido = @paciente ? @paciente.segundo_apellido : ''
    @rut = @paciente ? @paciente.rut : ''

    @presentaciones = @recomendacion.programa.medicamento_programas

    @tratamiento = @recomendacion.tratamientos.first
    @medicamento_programa_id = @tratamiento ? @tratamiento.medicamento_programa_id : ''
    @dias = @tratamiento ? @tratamiento.dias : ''
    @cantidad = @tratamiento ?  @tratamiento.cantidad : ''
    @esquema_tratamientos = @recomendacion.esquema_tratamientos
    @dia = @esquema_tratamientos.where(bloque_id: 1).first ? @esquema_tratamientos.where(bloque_id: 1).first.dosis : ''
    @tarde = @esquema_tratamientos.where(bloque_id: 2).first ? @esquema_tratamientos.where(bloque_id: 2).first.dosis : ''
    @noche = @esquema_tratamientos.where(bloque_id: 3).first ? @esquema_tratamientos.where(bloque_id: 3).first.dosis : ''

    @medico = @recomendacion.medico
    @nombre_medico = @medico ? @medico.nombres : ''
    @apellido1_medico = @medico ? @medico.primer_apellido : ''
    @apellido2_medico = @medico ? @medico.segundo_apellido : ''

    @prestador = @recomendacion.prestador
    @nombre_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre : ''
    @farmacia = @recomendacion.farmacia
    @nombre_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre : ''

    @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
    @fecha_receta = @documento_receta ? @documento_receta.fecha : ''
    
    @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
    @fecha_examen = @documento_examen ? @documento_examen.fecha : ''
    
     @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
     @leucocitos =@recomendacion.medicion_recomendaciones.where(medicion_id: 2).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 2).first.valor : ''
     @baciliformes = @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first.valor : ''
     @segmentados = @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first.valor : ''

    
  end

  # POST /recomendaciones
  # POST /recomendaciones.json
  def create
    @recomendacion = Recomendacion.new(recomendacion_params)

    respond_to do |format|
      if @recomendacion.save
        format.html { redirect_to edit_recomendacion_path(@recomendacion), notice: 'La solicitud se creo exitosamente' }
        format.json { render :show, status: :ok, location: @recomendacion }
      else
        format.html { render :edit }
        format.json { render json: @recomendacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recomendaciones/1
  # PATCH/PUT /recomendaciones/1.json
  def update
       # TODO
       # Parametrizar correctamente todo 
       @paciente = Paciente.find_or_create_by(recomendacion_params["atributos_paciente"])
       @recomendacion.paciente_id = @paciente.id

       @recomendacion.ejecutivo_id = current_user.id

       @prestador = Prestador.find_or_create_by(nombre: recomendacion_params["atributos_receta"]["prestador"])
       @farmacia = Farmacia.find_or_create_by(nombre: recomendacion_params["atributos_receta"]["farmacia"])
       
       nombre_medico = recomendacion_params["atributos_receta"]["medico_solicitante"].split
       @medico = Medico.find_or_create_by(nombres: nombre_medico[0], primer_apellido: nombre_medico[1], segundo_apellido: nombre_medico[2])
       @recomendacion.medico_id = @medico.id
       @recomendacion.prestador_id = @prestador.id
       @recomendacion.farmacia_id = @farmacia.id
       
       @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
       if @documento_receta.nil?
         DocumentoRecomendacion.create(recomendacion_id: @recomendacion.id, documento_programa_id: 1, fecha: recomendacion_params["atributos_receta"]["fecha_receta"])
       end
       
       @tratamientos = @recomendacion.tratamientos
       if @tratamientos.count == 0
         @tratamiento = Tratamiento.create(recomendacion_id: @recomendacion.id, medicamento_programa_id: recomendacion_params["atributos_receta"]["medicamento_programa_id"], dias: recomendacion_params["atributos_receta"]["dias"], cantidad: recomendacion_params["atributos_receta"]["cantidad"])
         @bloques = @recomendacion.programa.bloques
         @esquema_tratamientos = @recomendacion.esquema_tratamientos
         if @esquema_tratamientos.count == 0
           for bloque in @bloques
            EsquemaTratamiento.create(recomendacion_id: @recomendacion.id, tratamiento_id: @tratamiento.id, bloque_id: bloque.id, dosis: recomendacion_params["atributos_receta"]["#{bloque.nombre}"])
           end 
         end
       end


       @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
       if @documento_examen.nil?
         ExamenRecomendacion.create(recomendacion_id: @recomendacion.id, examen_programa_id: 1, fecha: recomendacion_params["atributos_examen"]["fecha_examen"])
       end

       @mediciones = @recomendacion.medicion_recomendaciones
       if @mediciones.count == 0
         MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 1, valor: recomendacion_params["atributos_examen"]["ran"])
         MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 2, valor: recomendacion_params["atributos_examen"]["leucocitos"])
         MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 3, valor: recomendacion_params["atributos_examen"]["baciliformes"])
         MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 4, valor: recomendacion_params["atributos_examen"]["segmentados"])
       end

    respond_to do |format|
      if @recomendacion.update(recomendacion_params)
         format.html { redirect_to @recomendacion, notice: 'Recomendacion se actualizo correctamente.' }
         format.json { render :show, status: :ok, location: @recomendacion }
      else
        format.html { render :edit }
        format.json { render json: @recomendacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recomendaciones/1
  # DELETE /recomendaciones/1.json
  def destroy
    @recomendacion.destroy
    respond_to do |format|
      format.html { redirect_to recomendaciones_url, notice: 'Recomendacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common  +  setup or constraints between actions.
    def set_recomendacion
      @recomendacion = Recomendacion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recomendacion_params
      params.require(:recomendacion).permit({atributos_examen: [:fecha_examen, :ran, :leucocitos, :baciliformes, :segmentados]}, {atributos_receta: [:fecha_receta, :prestador, :farmacia, :medico_solicitante, :medicamento_programa_id, :dia, :tarde, :noche, :dias, :cantidad]}, {atributos_paciente: [:rut, :nombres, :primer_apellido, :segundo_apellido]}, :id_recomendacion, :estado, :resultado, :caso_id, :programa_id, :paciente_id, :medico_id, :prestador_id, :farmacia_id, :qf_soporte_id, :ejecutivo_id, :fecha_hora_ingreso, :via_ingreso, :fecha_hora_respuesta, :observaciones, :con_alarma)
    end
end
