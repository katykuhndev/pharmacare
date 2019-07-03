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
    @iniciales_paciente = @recomendacion.paciente ? "#{@recomendacion.paciente.nombres[0]}#{@recomendacion.paciente.primer_apellido[0]}#{@recomendacion.paciente.primer_apellido[0]}" : ''
    @rut_paciente = @recomendacion.paciente ? @recomendacion.paciente.rut : ''
    @datos_medico = @recomendacion.medico ? "#{@recomendacion.medico.nombres} #{@recomendacion.medico.primer_apellido} #{@recomendacion.medico.segundo_apellido}"  : '' 
    @datos_prestador = @recomendacion.prestador ? @recomendacion.prestador.nombre  : '' 
    @datos_farmacia = @recomendacion.farmacia ? @recomendacion.farmacia.nombre  : ''
    @qf_soporte = @recomendacion.qf_soporte ? @recomendacion.qf_soporte.name : ''
    @ejecutivo = @recomendacion.ejecutivo ? @recomendacion.ejecutivo.name : ''
    
    #tratamimento 
    @tratamiento = @recomendacion.tratamientos.first
    @presentacion = @tratamiento ? (@tratamiento.medicamento_programa ? @tratamiento.medicamento_programa.nombre_comercial : '') : ''

    @dias = @tratamiento ? @tratamiento.dias : ''
    @cantidad = @tratamiento ?  @tratamiento.cantidad : ''
    @esquema_tratamientos = @recomendacion.esquema_tratamientos
    @dia = @esquema_tratamientos.where(bloque_id: 1).first ? @esquema_tratamientos.where(bloque_id: 1).first.dosis : ''
    @tarde = @esquema_tratamientos.where(bloque_id: 2).first ? @esquema_tratamientos.where(bloque_id: 2).first.dosis : ''
    @noche = @esquema_tratamientos.where(bloque_id: 3).first ? @esquema_tratamientos.where(bloque_id: 3).first.dosis : ''
     
    #fechas receta y examenes 
    @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
    @fecha_receta = @documento_receta ? (@documento_receta.fecha ? @documento_receta.fecha.strftime("%m/%d/%Y") : '')  : ''
     
    @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
    @fecha_examen = @documento_examen ? (@documento_examen.fecha ? @documento_examen.fecha.strftime("%m/%d/%Y") : '')  : ''
     
    @ran = @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 1).first.valor : ''
    @leucocitos =@recomendacion.medicion_recomendaciones.where(medicion_id: 2).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 2).first.valor : ''
    @baciliformes = @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 3).first.valor : ''
    @segmentados = @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first ? @recomendacion.medicion_recomendaciones.where(medicion_id: 4).first.valor : ''

    @alarma = @recomendacion.get_alarma

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
    @fecha_examen = @documento_examen ? @documento_examen.fecha  : ''
    
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
       # mejorar el codigo
       # este codigo solo se hizo para ael piloto
       
       @paciente = Paciente.find_or_create_by(recomendacion_params["atributos_paciente"])
       @recomendacion.paciente_id = @paciente.id

       @prestador = Prestador.find_or_create_by(nombre: recomendacion_params["atributos_receta"]["prestador"])
       @farmacia = Farmacia.find_or_create_by(nombre: recomendacion_params["atributos_receta"]["farmacia"])
       
       nombre_medico = recomendacion_params["atributos_receta"]["medico_solicitante"].split
       @medico = Medico.find_or_create_by(nombres: nombre_medico[0], primer_apellido: nombre_medico[1], segundo_apellido: nombre_medico[2])
       @recomendacion.medico_id = @medico.id
       @recomendacion.prestador_id = @prestador.id
       @recomendacion.farmacia_id = @farmacia.id
       
       @documento_receta = @recomendacion.documento_recomendaciones.where(documento_programa_id: 1).first
       if @documento_receta.nil?
         @documento_receta = DocumentoRecomendacion.create(recomendacion_id: @recomendacion.id, documento_programa_id: 1, fecha: recomendacion_params["atributos_receta"]["fecha_receta"])
       else
         @documento_receta = DocumentoRecomendacion.update(fecha: recomendacion_params["atributos_receta"]["fecha_receta"])
       end
       
       @tratamientos = @recomendacion.tratamientos
       if @tratamientos.count == 0 
         if recomendacion_params["atributos_receta"]["dias"].to_i>0 && recomendacion_params["atributos_receta"]["cantidad"].to_i>0
         if @documento_receta
             @tratamiento = Tratamiento.create(recomendacion_id: @recomendacion.id, medicamento_programa_id: recomendacion_params["atributos_receta"]["medicamento_programa_id"], dias: recomendacion_params["atributos_receta"]["dias"], cantidad: recomendacion_params["atributos_receta"]["cantidad"], documento_recomendacion_id: @documento_receta.id)
          else

             @tratamiento = Tratamiento.create(recomendacion_id: @recomendacion.id, medicamento_programa_id: recomendacion_params["atributos_receta"]["medicamento_programa_id"], dias: recomendacion_params["atributos_receta"]["dias"], cantidad: recomendacion_params["atributos_receta"]["cantidad"])
          end  
           @bloques = @recomendacion.programa.bloques
           @esquema_tratamientos = @tratamiento.esquema_tratamientos
           if @esquema_tratamientos.count == 0
             for bloque in @bloques
              EsquemaTratamiento.create(recomendacion_id: @recomendacion.id, tratamiento_id: @tratamiento.id, bloque_id: bloque.id, dosis: recomendacion_params["atributos_receta"]["#{bloque.nombre}"]) if recomendacion_params["atributos_receta"]["#{bloque.nombre}"]
             end 
           end
         end 
       else
         @tratamiento = @recomendacion.tratamientos.first
         @tratamiento.update(dias: recomendacion_params["atributos_receta"]["dias"], cantidad: recomendacion_params["atributos_receta"]["cantidad"])
         @esquema_tratamientos = @tratamiento.esquema_tratamientos
         if @esquema_tratamientos.count == 0
           @bloques = @recomendacion.programa.bloques
           for bloque in @bloques
            EsquemaTratamiento.create(recomendacion_id: @recomendacion.id, tratamiento_id: @tratamiento.id, bloque_id: bloque.id, dosis: recomendacion_params["atributos_receta"]["#{bloque.nombre}"]) if recomendacion_params["atributos_receta"]["#{bloque.nombre}"]
           end 
         else
           for esquema in @esquema_tratamientos
             case esquema.bloque.nombre
             when 'dia'
               esquema.update(dosis: recomendacion_params["atributos_receta"]["dia"])
             when 'tarde'
               esquema.update(dosis: recomendacion_params["atributos_receta"]["tarde"])   
             when 'noche'
               esquema.update(dosis: recomendacion_params["atributos_receta"]["noche"])
             end    
           end
         end
       end



       @documento_examen = @recomendacion.examen_recomendaciones.where(examen_programa_id: 1).first
       if @documento_examen.nil?
         ExamenRecomendacion.create(recomendacion_id: @recomendacion.id, examen_programa_id: 1, fecha: recomendacion_params["atributos_examen"]["fecha_examen"])
       else
         ExamenRecomendacion.update(fecha: recomendacion_params["atributos_examen"]["fecha_examen"])
       end


       @medicion_recomendaciones_ran = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 1)
       @medicion_recomendaciones_leucocitos = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 2)
       @medicion_recomendaciones_baciliformes = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 3)
       @medicion_recomendaciones_segmentados = @recomendacion.medicion_recomendaciones.where(recomendacion_id: @recomendacion.id, medicion_id: 4)

       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 1, valor: recomendacion_params["atributos_examen"]["ran"]) if @medicion_recomendaciones_ran.count == 0
       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 2, valor: recomendacion_params["atributos_examen"]["leucocitos"]) if @medicion_recomendaciones_leucocitos.count == 0
       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 3, valor: recomendacion_params["atributos_examen"]["baciliformes"]) if @medicion_recomendaciones_baciliformes.count == 0
       MedicionRecomendacion.create(recomendacion_id: @recomendacion.id, medicion_id: 4, valor: recomendacion_params["atributos_examen"]["segmentados"]) if @medicion_recomendaciones_segmentados.count == 0
       
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
       
       if @recomendacion.get_alarma
          @recomendacion.con_alarma = 1
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
