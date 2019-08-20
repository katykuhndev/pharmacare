class RecomendacionesController < ApplicationController
  before_action :set_recomendacion, only: [:show, :edit, :update, :destroy]
  
  autocomplete :paciente, :rut, :extra_data => [:nombres, :primer_apellido, :segundo_apellido]
  
  autocomplete :prestador, :nombre, :full => true

  autocomplete :farmacia, :nombre, :full => true

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
    @datos_paciente = @recomendacion.paciente ? @recomendacion.paciente.nombre_completo  : '' 
    @iniciales_paciente = @recomendacion.paciente ? @recomendacion.paciente.iniciales : ''
    @rut_paciente = @recomendacion.paciente ? @recomendacion.paciente.rut : ''
    @datos_medico = @recomendacion.medico ? "#{@recomendacion.medico.nombres} #{@recomendacion.medico.primer_apellido} #{@recomendacion.medico.segundo_apellido}"  : '' 
    @datos_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre  : '' 
    @datos_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre  : ''
    @qf_soporte = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''
    @ejecutivo = @recomendacion.ejecutivo ? @recomendacion.ejecutivo.name : ''
    
    #tratamimento 

    @tratamientos = @recomendacion.tratamientos
    
    @historicas = Recomendacion.historicas(@recomendacion)   

    @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
    @leucocitos =@recomendacion.medicion_recomendaciones.where(medicion_id: 2).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 2).first.valor : ''
    @baciliformes = @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first.valor : ''
    @segmentados = @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first.valor : ''

    @alarma = @recomendacion.alarma
    
    @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
    @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
 
    fecha_examen = @documento_examen.fecha if @documento_examen
    @fecha_examen = fecha_examen ? fecha_examen.strftime("%d/%m/%Y") : ''
    fecha_receta = @documento_receta.fecha if @documento_receta
    @fecha_receta = fecha_receta ? fecha_receta.strftime("%d/%m/%Y") : ''
    fecha_vencimiento_receta = @documento_receta.fecha_vencimiento if @documento_receta
    @fecha_vencimiento_receta = fecha_vencimiento_receta ? fecha_vencimiento_receta.strftime("%d/%m/%Y") : ''
    fecha_vencimiento_examen = @documento_examen.fecha_vencimiento if @documento_examen
    @fecha_vencimiento_examen = fecha_vencimiento_examen ? fecha_vencimiento_examen.strftime("%d/%m/%Y") : ''

    @rechazo_por_vencimiento = (@recomendacion.get_fecha_vencimiento_examen < Time.now) ? true : false if fecha_vencimiento_examen
    @titulo = (@recomendacion.aprobacion? || @recomendacion.aprobacion_con_reparos?) ? 'APROBADA' : 'RECHAZADA' 
    @accion = (@recomendacion.aprobacion? || @recomendacion.aprobacion_con_reparos?) ? 'APROBAR' : 'RECHAZAR' 

    @autorizador = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''

    respond_to do |format|
      format.html
      format.pdf do
          render :pdf => 'solicitud_recomendacion',
                 :layout => 'pdf.html',
                 :template => "recomendaciones/show.pdf.erb",
                 :disposition => 'inline',
                 :page_size => 'A4',
                 :encoding => 'UTF-8',
                 :margin => {:top => 20, :left => 20, :right => 20, :bottom => 10}
      end
    end

  end

  # GET /recomendaciones/new
  def new
    # TODO
    # Agregar formulario para escoger laboratorios
    @laboratorio = Laboratorio.find(1)
    @programas = @laboratorio.programas
    @recomendacion = Recomendacion.new
    @recomendacion.ejecutivo_id = current_user.id
    
  end

  # GET /recomendaciones/1/edit
  def edit
    # TODO
    # Parametrizar correctamente todo 

    @paciente = @recomendacion.paciente
    @nombres_paciente = @recomendacion.paciente ? @recomendacion.paciente.nombres  : '' 
    @primer_apellido_paciente = @recomendacion.paciente ? @recomendacion.paciente.primer_apellido  : '' 
    @segundo_apellido_paciente = @recomendacion.paciente ? @recomendacion.paciente.segundo_apellido  : '' 
    @rut_paciente = @recomendacion.paciente ? @recomendacion.paciente.rut  : '' 
    
    @presentaciones = @recomendacion.programa.medicamento_programas

    @tratamientos = @recomendacion.tratamientos

    @medico = @recomendacion.medico
    @nombre_medico = @medico ? @medico.nombres : ''
    @apellido1_medico = @medico ? @medico.primer_apellido : ''
    @apellido2_medico = @medico ? @medico.segundo_apellido : ''

    @prestador = @recomendacion.prestador
    @nombre_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre : ''
    @farmacia = @recomendacion.farmacia
    @nombre_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre : ''
    
    @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
    @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
    @fecha_examen = @recomendacion.get_fecha_examen
    @fecha_receta = @recomendacion.get_fecha_receta
    
    @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
    @leucocitos =@recomendacion.medicion_recomendaciones.where(medicion_id: 2).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 2).first.valor : ''
    @baciliformes = @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first.valor : ''
    @segmentados = @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first.valor : ''
    
  end

  # POST /recomendaciones
  # POST /recomendaciones.json
  def create
    @recomendacion = Recomendacion.new(recomendacion_params)
    @recomendacion.ejecutivo_id = current_user.id
    respond_to do |format|
      if @recomendacion.save
        format.html { redirect_to edit_recomendacion_path(@recomendacion), notice: 'La solicitud se creo exitosamente' }
        format.json { render :show, status: :ok, location: @recomendacion }
      else
        format.html { render :new }
        format.json { render json: @recomendacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recomendaciones/1
  # PATCH/PUT /recomendaciones/1.json
  def update
       # TODO
       # Parametrizar correctamente todo 
       # mejorar el codigo
       # este codigo solo se hizo para ael piloto
       atributos_paciente = recomendacion_params["atributos_paciente"]
       rut = atributos_paciente.delete(:paciente_rut)
       atributos_paciente[:rut] = rut
       @paciente = Paciente.find_or_create_by(atributos_paciente)
       @recomendacion.paciente_id = @paciente.id

       #@prestador = Prestador.find_or_create_by(nombre: recomendacion_params["prestador_nombre"])
       #@farmacia = Farmacia.find_or_create_by(nombre: recomendacion_params["atributos_receta"]["farmacia_nombre"])
       
       #nombre_medico = recomendacion_params["atributos_receta"]["medico"].split if recomendacion_params["atributos_receta"]["medico"]
       #@medico = Medico.find_or_create_by(nombres: nombre_medico[0], primer_apellido: nombre_medico[1], segundo_apellido: nombre_medico[2]) if nombre_medico
      # @recomendacion.medico_id = @medico.id if @medico
       #@recomendacion.prestador_id = @prestador.id
       #@recomendacion.farmacia_id = @farmacia.id
       
      @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
      if @documento_receta.nil?
        @documento_receta = DocumentoRecomendacion.create(recomendacion_id: @recomendacion.id, documento_programa_id: 1, fecha: recomendacion_params["atributos_receta"]["fecha_receta"])
      else
        @documento_receta.update(fecha: recomendacion_params["atributos_receta"]["fecha_receta"])
      end

      fecha_vencimiento = @recomendacion.get_fecha_vencimiento_receta
      if fecha_vencimiento
        @documento_receta.update(fecha_vencimiento: fecha_vencimiento)
      end 



      @documento_receta.receta.attach(recomendacion_params["atributos_receta"]["receta"])
      @documento_receta.nombrar_archivo_receta

      if recomendacion_params["atributos_tratamiento"]["medicamento_programa_id"].to_i > 0 && recomendacion_params["atributos_tratamiento"]["esquema_horario_id"].to_i > 0 && recomendacion_params["atributos_tratamiento"]["dias"].to_i > 0 && recomendacion_params["atributos_tratamiento"]["cantidad"].to_i > 0
       @tratamiento = Tratamiento.create(recomendacion_id: @recomendacion.id, esquema_horario_id: recomendacion_params["atributos_tratamiento"]["esquema_horario_id"], medicamento_programa_id: recomendacion_params["atributos_tratamiento"]["medicamento_programa_id"], dias: recomendacion_params["atributos_tratamiento"]["dias"], cantidad: recomendacion_params["atributos_tratamiento"]["cantidad"], documento_recomendacion_id: @documento_receta.id)
       @bloques = @recomendacion.programa.bloques
       for bloque in @bloques
        if recomendacion_params["atributos_tratamiento"]["#{bloque.nombre}"] != ''
          EsquemaTratamiento.create(recomendacion_id: @recomendacion.id, tratamiento_id: @tratamiento.id, bloque_id: bloque.id, dosis: recomendacion_params["atributos_tratamiento"]["#{bloque.nombre}"].to_f) 
        end
       end 
      end     

      @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
      if @documento_examen.nil?
       @documento_examen = ExamenRecomendacion.create(recomendacion_id: @recomendacion.id, examen_programa_id: 1, fecha: recomendacion_params["atributos_examen"]["fecha_examen"])
      else
        @documento_examen.update(fecha: recomendacion_params["atributos_examen"]["fecha_examen"])
      end

      fecha_vencimiento = @recomendacion.get_fecha_vencimiento_examen
      if fecha_vencimiento
        @documento_examen.update(fecha_vencimiento: fecha_vencimiento)
      end 

      
      @documento_examen.examen.attach(recomendacion_params["atributos_examen"]["examen"])
      @documento_examen.nombrar_archivo_examen
       
       @medicion_recomendaciones_ran = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 1)
       @medicion_recomendaciones_leucocitos = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 2)
       @medicion_recomendaciones_baciliformes = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 3)
       @medicion_recomendaciones_segmentados = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 4)

       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 1, valor: recomendacion_params["atributos_examen"]["ran"].to_f) if @medicion_recomendaciones_ran.count == 0
       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 2, valor: recomendacion_params["atributos_examen"]["leucocitos"].to_f) if @medicion_recomendaciones_leucocitos.count == 0
       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 3, valor: recomendacion_params["atributos_examen"]["baciliformes"].to_f) if @medicion_recomendaciones_baciliformes.count == 0
       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 4, valor: recomendacion_params["atributos_examen"]["segmentados"].to_f) if @medicion_recomendaciones_segmentados.count == 0
       
       @medicion_recomendaciones = @recomendacion.medicion_recomendaciones
        for medicion_recomendacion in @medicion_recomendaciones
         case medicion_recomendacion.medicion_id
         when 1
           medicion_recomendacion.update(valor: recomendacion_params["atributos_examen"]["ran"])
         when 2
           medicion_recomendacion.update(valor: recomendacion_params["atributos_examen"]["leucocitos"])   
         when 3
           medicion_recomendacion.update(valor: recomendacion_params["atributos_examen"]["baciliformes"])
         when 4
           medicion_recomendacion.update(valor: recomendacion_params["atributos_examen"]["segmentados"])  
         end    
        end
       
       @recomendacion.resolucion_recomendacion

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
      params.require(:recomendacion).permit(:prestador_nombre, :farmacia_nombre, :medico, :medico_nombre, { atributos_examen: [:fecha_examen, :examen, :ran, :leucocitos, :baciliformes, :segmentados]}, {atributos_receta: [:fecha_receta, :receta]}, {atributos_tratamiento: [:esquema_horario_id, :dia, :tarde, :noche, :am, :pm, :dia_entero, :dias, :cantidad,  :medicamento_programa_id]}, {atributos_paciente: [:paciente_rut, :nombres, :primer_apellido, :segundo_apellido]}, :id_recomendacion, :estado, :resultado, :caso_id, :programa_id, :paciente_id, :medico_id, :prestador_id, :farmacia_id, :qf_soporte_id, :ejecutivo_id, :fecha_hora_ingreso, :via_ingreso, :fecha_hora_respuesta, :observaciones, :con_alarma)
    end
end
