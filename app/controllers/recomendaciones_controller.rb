class RecomendacionesController < ApplicationController
  before_action :set_recomendacion, only: [:show, :edit, :update, :destroy]
  
  autocomplete :paciente, :rut, :extra_data => [:nombres, :primer_apellido, :segundo_apellido]
  
  autocomplete :prestador, :nombre, :full => true

  autocomplete :farmacia, :nombre, :full => true

  # GET /recomendaciones
  # GET /recomendaciones.json
  def index
    @query = Recomendacion.ransack(params[:q])

    @fecha_desde = Time.now.beginning_of_month.strftime("%Y-%m-%d")
    @fecha_hasta = Time.now.strftime("%Y-%m-%d")
    if params[:q] && params[:q][:fecha_hora_ingreso_gteq]!='' && params[:q][:fecha_hora_ingreso_lteq]!=''
      @fecha_desde = params[:q][:fecha_hora_ingreso_gteq]
      @fecha_hasta = params[:q][:fecha_hora_ingreso_lteq]
      @recomendaciones_informe = @query.result.includes(:programa,:paciente,:medico,:prestador,:farmacia,:qf_soporte,:ejecutivo).order('created_at desc')
    else
      @recomendaciones_informe = @query.result.where(" fecha_hora_ingreso >= '#{@fecha_desde}' and fecha_hora_ingreso <= '#{@fecha_hasta}' ").includes(:programa,:paciente,:medico,:prestador,:farmacia,:qf_soporte,:ejecutivo).order('created_at desc')
    end 
    @recomendaciones = @recomendaciones_informe.page(params[:page])

    @pacientes = []
    for rec in @recomendaciones_informe
      @pacientes<<rec.paciente_id
    end  
    @pacientes = @pacientes.uniq

    respond_to do |format|
      format.html
      format.pdf do
          render :pdf => "informe",
                 :layout => 'pdf.html',
                 :template => "recomendaciones/index.pdf.erb",
                 :disposition => 'attachment',
                 :page_size => 'A4',
                 :encoding => 'UTF-8',
                 :margin => {:top => 70, :left => 20, :right => 20, :bottom => 10},
                 :header => {:html => { :template => 'recomendaciones/cabecera.pdf.erb'},
                  :margin => { :top => 10, :bottom => 10 }, # margin on header
                 }
      end
    end
  end

  def edit_cierre
    @recomendacion = Recomendacion.find(params[:id])
  end 

  def cerrar
    @recomendacion = Recomendacion.find(params[:id])
    respond_to do |format|
        if params['rechazo_administrativo']
          parametros = {fecha_hora_respuesta: Time.now, resultado: 'rechazo_administrativo', resolucion_qf: 'rechazada', estado: 'cerrada' }
        elsif params['rechazo_tecnico']
          parametros = {fecha_hora_respuesta: Time.now, resultado: 'rechazo_tecnico', resolucion_qf: 'rechazada', estado: 'cerrada' }
        elsif params['aprobacion_con_reparos']
          parametros = {fecha_hora_respuesta: Time.now, resultado: 'aprobacion_con_reparos', resolucion_qf: 'aprobada', estado: 'cerrada' }
        elsif params['aprobacion']
          parametros = {fecha_hora_respuesta: Time.now, resultado: 'aprobacion', resolucion_qf: 'aprobada', estado: 'cerrada' }
        end  
        @caso = @recomendacion.caso
        if @caso && @caso.qf_soporte_id.nil? && @caso.fecha_hora_ingreso.present? && @caso.fecha_hora_ingreso.today?
           @caso.qf_soporte_id = @recomendacion.qf_soporte_id
           @caso.save
        end 
        parametros = parametros.merge(recomendacion_params)
        @recomendacion.update(parametros) 
        filename = @recomendacion.get_nombre_carta_recomendacion

        programa = @recomendacion.programa    
        @paciente = @recomendacion.paciente
        @datos_paciente = @paciente ? @paciente.nombre_completo  : ''
        @rut_paciente = @paciente ? @paciente.rut : ''
        @datos_medico = @recomendacion.medico ? "#{@recomendacion.medico.nombres} #{@recomendacion.medico.primer_apellido} #{@recomendacion.medico.segundo_apellido}"  : '' 
        @datos_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre  : '' 
        @datos_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre  : ''
        @qf_soporte = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''           
        @iniciales_paciente = @caso ? @caso.codigo : (@paciente ? @paciente.iniciales : '')
        @tratamientos = @recomendacion.tratamientos
        @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
        @alarma = @recomendacion.alarma
        fecha_examen = @recomendacion.get_fecha_examen
        @fecha_examen = fecha_examen ? fecha_examen.strftime("%d/%m/%Y") : ''
        fecha_receta = @recomendacion.get_fecha_receta
        @fecha_receta = fecha_receta ? fecha_receta.strftime("%d/%m/%Y") : ''
        @titulo = @recomendacion.aprobada? ? 'APROBADA' : 'RECHAZADA' 
        @accion = @recomendacion.aprobada? ? 'APROBAR' : 'RECHAZAR' 
        @autorizador = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''
        pdf_html = ActionController::Base.new.render_to_string(
          template: 'recomendaciones/show.pdf.erb', 
          :locals => {
              :@titulo => @titulo,
              :@iniciales_paciente => @iniciales_paciente,
              :@recomendacion => @recomendacion,
              :@datos_paciente => @datos_paciente,
              :@rut_paciente => @rut_paciente,
              :@alarma => @alarma,
              :@ran => @ran,
              :@fecha_examen => @fecha_examen,
              :@fecha_receta => @fecha_receta,
              :@datos_prestador => @datos_prestador,
              :@datos_farmacia => @datos_farmacia,
              :@datos_medico => @datos_medico,
              :@accion => @accion,
              :@tratamientos => @tratamientos,
              :@autorizador => @autorizador
          },
          layout: 'pdf')
        carta_pdf = WickedPdf.new.pdf_from_string(pdf_html,:encoding => 'UTF-8',:page_size => 'A4',:margin => {:top => 20, :left => 20, :right => 20, :bottom => 10})
        @recomendacion.carta_pdf.attach(io: StringIO.new(carta_pdf), filename: "#{filename}.pdf", content_type: "application/pdf")
        RecomendacionMailer.with(recomendacion: @recomendacion).informe_recomendacion.deliver_later
        format.html { redirect_to @recomendacion, notice: 'Recomendacion se cerró correctamente.' }
        format.json { render :show, status: :ok, location: @recomendacion }
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
    @documento_caso = @caso ? @caso.get_documentos_caso : nil
    @iniciales_paciente = @caso ? @caso.codigo : (@paciente ? @paciente.iniciales : '')
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
    if @caso
      examen_programa = ExamenPrograma.where("programa_id = ? and tipo_control_id = ? and examen_id = ?", programa.id, @caso.tipo_control_id, 1).first
      @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: examen_programa.id).first
    end
 
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
    filename =  @recomendacion.get_nombre_carta_recomendacion
    respond_to do |format|
      format.html
      format.pdf do
          render :pdf => filename,
                 :layout => 'pdf.html',
                 :template => "recomendaciones/show.pdf.erb",
                 :disposition => 'attachment',
                 :page_size => 'A4',
                 :encoding => 'UTF-8',
                 :margin => {:top => 10, :left => 20, :right => 20, :bottom => 10}      
      end
    end
  end

  def encuentra_caso
    recomendacion = Recomendacion.find(params[:recomendacion_id])
    programa = recomendacion.programa
    @caso = Caso.where("programa_id = ? and paciente_id = ? ", programa.id, params[:paciente_id]).first
    respond_to do |format|
     format.json {render json: @caso}
    end
  end  

  def enmendar
    @recomendacion = Recomendacion.find(params[:id])
    @recomendacion_nueva = @recomendacion.dup
    id_recomendacion_nuevo = @recomendacion.get_id_recomendacion_enmendado
    @recomendacion_nueva.id_recomendacion = id_recomendacion_nuevo
    @recomendacion_nueva.estado = 0
    @recomendacion_nueva.save(validate: false)
    @recomendacion.tratamientos.each do |tratamiento|
      tratamiento_nuevo = tratamiento.dup
      tratamiento_nuevo.recomendacion_id = @recomendacion_nueva.id
      tratamiento_nuevo.created_at = Time.now
      tratamiento_nuevo.updated_at = Time.now
      tratamiento_nuevo.save
      tratamiento.esquema_tratamientos.each do |esquema_tratamiento|
        esquema_tratamiento_nuevo = esquema_tratamiento.dup
        esquema_tratamiento_nuevo.tratamiento_id = tratamiento_nuevo.id
        esquema_tratamiento_nuevo.recomendacion_id = @recomendacion_nueva.id
        esquema_tratamiento_nuevo.created_at = Time.now
        esquema_tratamiento_nuevo.updated_at = Time.now        
        esquema_tratamiento_nuevo.save

      end
    end  
    @recomendacion.documento_recomendaciones.each do |documento_recomendacion|
      documento_recomendacion_nueva = documento_recomendacion.dup
      documento_recomendacion_nueva.recomendacion_id = @recomendacion_nueva.id
      documento_recomendacion_nueva.ejecutivo_id = current_user.id
      documento_recomendacion_nueva.nombre = nil
      documento_recomendacion_nueva.fecha = nil
      documento_recomendacion_nueva.created_at = Time.now
      documento_recomendacion_nueva.updated_at = Time.now
      documento_recomendacion_nueva.save
      #documento_recomendacion.receta.open do |tempfile|
      #documento_recomendacion_nueva.receta.attach({
       # io: tempfile, 
        #filename: documento_recomendacion.receta.blob.filename, 
        #content_type: documento_recomendacion.receta.blob.content_type 
      #})
      #end

    end  
    @recomendacion.examen_recomendaciones.each do |examen_recomendacion|
      examen_recomendacion_nueva = examen_recomendacion.dup
      examen_recomendacion_nueva.recomendacion_id = @recomendacion_nueva.id
      examen_recomendacion_nueva.ejecutivo_id = current_user.id
      examen_recomendacion_nueva.nombre = nil
      examen_recomendacion_nueva.fecha = nil
      examen_recomendacion_nueva.created_at = Time.now
      examen_recomendacion_nueva.updated_at = Time.now
      examen_recomendacion_nueva.save
    end  
    @recomendacion.medicion_recomendaciones.each do |medicion_recomendacion|
      medicion_recomendacion_nueva = medicion_recomendacion.dup
      medicion_recomendacion_nueva.recomendacion_id = @recomendacion_nueva.id
      medicion_recomendacion_nueva.created_at = Time.now
      medicion_recomendacion_nueva.updated_at = Time.now
      medicion_recomendacion_nueva.save
    end  
    redirect_to edit_recomendacion_path(@recomendacion_nueva)
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
    @documento_caso = @caso ? @caso.get_documentos_caso : nil

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
    if @caso
      examen_programa = ExamenPrograma.where("programa_id = ? and tipo_control_id = ? and examen_id = ?", programa.id, @caso.tipo_control_id, 1).first
      @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: examen_programa.id).first
    end
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
           @caso = Caso.create(paciente_id: @paciente.id, programa_id: programa.id, ejecutivo_id: current_user.id, codigo: codigo_correcto, tipo_control_id: 2, via_ingreso: @recomendacion.via_ingreso )
           @recomendacion.caso = @caso
          end 
        else
          @recomendacion.paciente_id = @paciente.id
          @caso = Caso.where("programa_id = ? and paciente_id = ? ", programa.id, @paciente.id).first
          if @caso.nil?
            inicial = programa.inicial
            codigo = "#{inicial}-#{@paciente.iniciales}"
            codigo_correcto = Caso.busca_codigo(codigo,programa.id)
            @caso = Caso.create(paciente_id: @paciente.id, programa_id: programa.id, ejecutivo_id: current_user.id, codigo: codigo_correcto, tipo_control_id: 2, via_ingreso: @recomendacion.via_ingreso )
          end  
          @recomendacion.caso = @caso
        end

        if @caso && params["tipo_control"]
          @caso.tipo_control_id=params["tipo_control"]
          @caso.save
        end

        @documento_caso = @caso ? @caso.get_documentos_caso : nil
        if @caso && @documento_caso.nil?
          @documento_caso = DocumentoCaso.create(caso_id: @caso.id, documento_programa_id: 2, ejecutivo_id: current_user.id, fecha: recomendacion_params["atributos_paciente"]["fecha_consentimiento_informado"])
        end
        if @documento_caso && recomendacion_params["atributos_paciente"]["consentimiento_informado"]
          @documento_caso.consentimiento_informado.attach(recomendacion_params["atributos_paciente"]["consentimiento_informado"])
          @documento_caso.nombrar_archivo_consentimiento_informado  
        end    
        if @documento_caso && recomendacion_params["atributos_paciente"]["fecha_consentimiento_informado"]
          @documento_caso.update(fecha: recomendacion_params["atributos_paciente"]["fecha_consentimiento_informado"])
        end   
      end
       
      @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
      if @documento_receta.nil?
        @documento_receta = DocumentoRecomendacion.create(recomendacion_id: @recomendacion.id, documento_programa_id: 1, fecha: recomendacion_params["atributos_receta"]["fecha_receta"], ejecutivo_id: current_user.id)
      else
        @documento_receta.update(fecha: recomendacion_params["atributos_receta"]["fecha_receta"])
      end

      fecha_vencimiento = @recomendacion.get_fecha_vencimiento_receta
      @documento_receta.update(fecha_vencimiento: fecha_vencimiento)
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
  
      if @caso
        @documento_examen = @recomendacion.examen_recomendaciones.first
        examen_programa = ExamenPrograma.where("programa_id = ? and tipo_control_id = ? ", programa.id, @caso.tipo_control_id).first
        if @documento_examen.nil?    
          @documento_examen = ExamenRecomendacion.create(recomendacion_id: @recomendacion.id, examen_programa_id: examen_programa ? examen_programa.id : 2, fecha: recomendacion_params["atributos_examen"]["fecha_examen"], ejecutivo_id: current_user.id)
        else
          @documento_examen.update(fecha: recomendacion_params["atributos_examen"]["fecha_examen"], examen_programa_id: examen_programa.id)
        end
   
        fecha_vencimiento = @recomendacion.get_fecha_vencimiento_examen
        @documento_examen.update(fecha_vencimiento: fecha_vencimiento)
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
      params.require(:recomendacion).permit(:comentarios, :prestador_nombre, :farmacia_nombre, :medico, :medico_nombre, { atributos_examen: [:fecha_examen, :examen, :ran, :leucocitos, :baciliformes, :segmentados]}, {atributos_receta: [:fecha_receta, :receta]}, {atributos_tratamiento: [:esquema_horario_id, :dia, :tarde, :noche, :am, :pm, :dia_entero, :dias, :cantidad,  :medicamento_programa_id]}, {atributos_paciente: [:paciente_rut, :nombres, :primer_apellido, :segundo_apellido, :consentimiento_informado, :fecha_consentimiento_informado]}, :id_recomendacion, :estado, :resultado, :caso_id, :programa_id, :paciente_id, :medico_id, :prestador_id, :farmacia_id, :qf_soporte_id, :ejecutivo_id, :fecha_hora_ingreso, :via_ingreso, :fecha_hora_respuesta, :observaciones, :con_alarma, :carta_pdf)
    end
end
