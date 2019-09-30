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

  def edit_cierre
    @recomendacion = Recomendacion.find(params[:id])
  end 

  def cerrar
    @recomendacion = Recomendacion.find(params[:id])
    if params['rechazo_administrativo']
      parametros = recomendacion_params.merge({fecha_hora_respuesta: Time.now, resultado: 'rechazo_administrativo', resolucion_qf: 'rechazada', estado: 'cerrada' })
    elsif params['rechazo_tecnico']
      parametros = recomendacion_params.merge({fecha_hora_respuesta: Time.now, resultado: 'rechazo_tecnico', resolucion_qf: 'rechazada', estado: 'cerrada' })
    elsif params['aprobacion_con_reparos']
      parametros = recomendacion_params.merge({fecha_hora_respuesta: Time.now, resultado: 'aprobacion_con_reparos', resolucion_qf: 'aprobada', estado: 'cerrada' })
    elsif params['aprobacion']
      parametros = recomendacion_params.merge({fecha_hora_respuesta: Time.now, resultado: 'aprobacion', resolucion_qf: 'aprobada', estado: 'cerrada' })
    end  
    respond_to do |format|
      if @recomendacion.update(parametros)
         format.html { redirect_to @recomendacion, notice: 'Recomendacion se cerró correctamente.' }
         format.json { render :show, status: :ok, location: @recomendacion }
      else
        format.html { render :edit_cierre }
        format.json { render json: @recomendacion.errors, status: :unprocessable_entity }
      end
     end 
  end 

  # GET /recomendaciones/1
  # GET /recomendaciones/1.json
  def show
    # TODO
    # Parametrizar correctamente todo 
    programa = @recomendacion.programa    
    @paciente = @recomendacion.paciente
    @datos_paciente = @paciente ? @paciente.nombre_completo  : ''
    @rut_paciente = @paciente ? @paciente.rut : ''
    @datos_medico = @recomendacion.medico ? "#{@recomendacion.medico.nombres} #{@recomendacion.medico.primer_apellido} #{@recomendacion.medico.segundo_apellido}"  : '' 
    @datos_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre  : '' 
    @datos_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre  : ''
    @qf_soporte = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''
    @ejecutivo = @recomendacion.ejecutivo ? @recomendacion.ejecutivo.name : ''
     
    @caso = @paciente ? Caso.where("programa_id = ? and paciente_id = ? ", programa.id, @paciente.id).first : nil 
    @documento_caso = @caso ? @caso.tiene_documentos_asociados? : nil
    @iniciales_paciente = @caso ? @caso.codigo : @paciente.iniciales

    #tratamimento 

    @tratamientos = @recomendacion.tratamientos
    
    @historicas = Recomendacion.historicas(@recomendacion)   

    @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
    @leucocitos =@recomendacion.medicion_recomendaciones.where(medicion_id: 2).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 2).first.valor : ''
    @baciliformes = @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first.valor : ''
    @segmentados = @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first.valor : ''

    @alarma = @recomendacion.alarma
    
    # TODO 
    # Adaptar esto al generico

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

    @rechazo_por_vencimiento = (fecha_vencimiento_examen ? (fecha_vencimiento_examen < Time.now) : false) ? true : false
    @titulo = @recomendacion.aprobada? ? 'APROBADA' : 'RECHAZADA' 
    @accion = @recomendacion.aprobada? ? 'APROBAR' : 'RECHAZAR' 

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

  def encuentra_caso
    @caso = Caso.where("programa_id = ? and paciente_id = ? ", params[:programa_id], params[:paciente_id]).first
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
    programa = @recomendacion.programa
    @paciente = @recomendacion.paciente
    @nombres_paciente = @paciente ? @paciente.nombres  : '' 
    @primer_apellido_paciente = @paciente ? @paciente.primer_apellido  : '' 
    @segundo_apellido_paciente = @paciente ? @paciente.segundo_apellido  : '' 
    @rut_paciente = @paciente ? @paciente.rut  : '' 
    @caso = @paciente ? Caso.where("programa_id = ? and paciente_id = ? ", programa.id, @paciente.id).first : nil 
    @documento_caso = @caso ? @caso.tiene_documentos_asociados? : nil

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
      programa = @recomendacion.programa
      atributos_paciente = recomendacion_params["atributos_paciente"]
      if atributos_paciente
        atributos_paciente.delete(:consentimiento_informado)
        atributos_paciente.delete(:fecha_consentimiento_informado)
        rut = atributos_paciente.delete(:paciente_rut)
        atributos_paciente[:rut] = rut
        se_puede_crear = true
        atributos_paciente.each do |key,value|
          if value.empty?
            se_puede_crear = false
            break
          else
            atributos_paciente["#{key}"] = value.strip.capitalize
          end
        end 
        @paciente = Paciente.find_or_initialize_by(atributos_paciente)
        if @paciente.new_record? 
          if se_puede_crear
           @paciente.save 
           @recomendacion.paciente_id = @paciente.id
           inicial = programa.inicial
           codigo = "#{inicial}-#{@paciente.iniciales}"
           codigo_correcto = Caso.busca_codigo(codigo,programa.id)
           # TODO 
           # mejorar tipo_control_id, al crear por defecto se usa semanal en caso de lodux
           @caso = Caso.create(paciente_id: @paciente.id, programa_id: programa.id, ejecutivo_id: @recomendacion.ejecutivo_id, codigo: codigo_correcto, tipo_control_id: 2)
           @recomendacion.caso = @caso
          end 
        else
          @recomendacion.paciente_id = @paciente.id
          @caso = Caso.where("programa_id = ? and paciente_id = ? ", programa.id, @paciente.id).first
          if @caso.nil?
            inicial = programa.inicial
            codigo = "#{inicial}-#{@paciente.iniciales}"
            codigo_correcto = Caso.busca_codigo(codigo,programa.id)
            @caso = Caso.create(paciente_id: @paciente.id, programa_id: programa.id, ejecutivo_id: @recomendacion.ejecutivo_id, codigo: codigo_correcto, tipo_control_id: 2)
          end  
          @recomendacion.caso = @caso
        end
        @documento_caso = @caso ? @caso.documento_casos.where(documento_programa_id: 2).first : nil
        if @caso && @documento_caso.nil?
          @documento_caso = DocumentoCaso.create(caso_id: @caso.id, documento_programa_id: 2, ejecutivo_id: @recomendacion.ejecutivo_id, fecha: recomendacion_params["atributos_paciente"]["fecha_consentimiento_informado"])
        end
        if recomendacion_params["atributos_paciente"]["consentimiento_informado"]
          @documento_caso.consentimiento_informado.attach(recomendacion_params["atributos_paciente"]["consentimiento_informado"])
          @documento_caso.nombrar_archivo_consentimiento_informado  
        end    
      end
         
      if @caso && params["tipo_control"]
        @caso.tipo_control_id=params["tipo_control"]
        @caso.save
      end

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
      if @caso && @documento_examen.nil?
        examen_programa = ExamenPrograma.where("programa_id = ? and tipo_control_id = ? ", programa.id, @caso.tipo_control_id).first
        @documento_examen = ExamenRecomendacion.create(recomendacion_id: @recomendacion.id, examen_programa_id: examen_programa ? examen_programa.id : 2, fecha: recomendacion_params["atributos_examen"]["fecha_examen"])
      else
        @documento_examen.update(fecha: recomendacion_params["atributos_examen"]["fecha_examen"]) if @caso
      end
 
      fecha_vencimiento = @recomendacion.get_fecha_vencimiento_examen
      if fecha_vencimiento
        @documento_examen.update(fecha_vencimiento: fecha_vencimiento)
      end 

      if @caso
        @documento_examen.examen.attach(recomendacion_params["atributos_examen"]["examen"])
        @documento_examen.nombrar_archivo_examen
      end 
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

    respond_to do |format|
      if @recomendacion.update(recomendacion_params)
         @recomendacion.resolucion_recomendacion
         
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
      params.require(:recomendacion).permit(:prestador_nombre, :farmacia_nombre, :medico, :medico_nombre, { atributos_examen: [:fecha_examen, :examen, :ran, :leucocitos, :baciliformes, :segmentados]}, {atributos_receta: [:fecha_receta, :receta]}, {atributos_tratamiento: [:esquema_horario_id, :dia, :tarde, :noche, :am, :pm, :dia_entero, :dias, :cantidad,  :medicamento_programa_id]}, {atributos_paciente: [:paciente_rut, :nombres, :primer_apellido, :segundo_apellido, :consentimiento_informado, :fecha_consentimiento_informado]}, :id_recomendacion, :estado, :resultado, :caso_id, :programa_id, :paciente_id, :medico_id, :prestador_id, :farmacia_id, :qf_soporte_id, :ejecutivo_id, :fecha_hora_ingreso, :via_ingreso, :fecha_hora_respuesta, :observaciones, :con_alarma)
    end
end
