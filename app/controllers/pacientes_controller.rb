class PacientesController < ApplicationController
  before_action :set_paciente, only: [:show, :edit, :update, :destroy]

  # GET /pacientes
  # GET /pacientes.json
  def index
    @query = Paciente.ransack(params[:q])
    @pacientes = @query.result.includes(:comuna).page(params[:page])
  end

  # GET /pacientes/1
  # GET /pacientes/1.json
  def show
    @caso = @paciente.casos.first
    @documento_consentimiento_informado = @caso.documento_casos.where(documento_programa_id: 2).first
    @documento_certificado_permanencia = @caso.documento_casos.where(documento_programa_id: 3).first
    @documento_otro = @caso.documento_casos.where(documento_programa_id: 4).first
    @recomendaciones_historicas = @paciente.recomendaciones_historicas
  end

  # GET /pacientes/new
  def new
    @paciente = Paciente.new
  end

  # GET /pacientes/1/edit
  def edit
  end

  def edit_caso_paciente
    @paciente = Paciente.find(params[:id])
    @caso = @paciente.casos.first
    @documento_consentimiento_informado = @caso.documento_casos.where(documento_programa_id: 2).first
    @documento_certificado_permanencia = @caso.documento_casos.where(documento_programa_id: 3).first
    @documento_otro = @caso.documento_casos.where(documento_programa_id: 4).first
    #@documento_caso = @caso ? @caso.get_documentos_caso : nil
  end

  def guardar_archivos
    @paciente = Paciente.find(params[:id])
    @caso = @paciente.casos.first
    @documento_consentimiento_informado = @caso.documento_casos.where(documento_programa_id: 2).first
    @documento_certificado_permanencia = @caso.documento_casos.where(documento_programa_id: 3).first
    #@documento_otro = @caso.documento_casos.where(documento_programa_id: 4).first
    #@documento_caso = @caso ? @caso.get_documentos_caso : nil
    if @documento_consentimiento_informado.nil?
      @documento_consentimiento_informado = DocumentoCaso.new(caso_id: @caso.id, documento_programa_id: 2, ejecutivo_id: current_user.id, fecha: paciente_params["fecha_consentimiento_informado"])
    end
    consentimiento_form = paciente_params["consentimiento_informado"]
    if consentimiento_form
      @documento_consentimiento_informado.consentimiento_informado.attach(consentimiento_form)
      @documento_consentimiento_informado.nombrar_archivo_consentimiento_informado  
    end    
    fecha_consentimiento_form = paciente_params["fecha_consentimiento_informado"]
    @documento_consentimiento_informado.fecha = fecha_consentimiento_form  
    @documento_consentimiento_informado.save

    if @documento_certificado_permanencia.nil?
      @documento_certificado_permanencia = DocumentoCaso.new(caso_id: @caso.id, documento_programa_id: 3, ejecutivo_id: current_user.id, fecha: paciente_params["fecha_certificado_permanencia"])
    end
    certificado_form = paciente_params["certificado_permanencia"]
    if certificado_form
      @documento_certificado_permanencia.certificado_permanencia.attach(certificado_form)
      @documento_certificado_permanencia.nombrar_archivo_certificado_permanencia 
    end    
    fecha_certificado_form = paciente_params["fecha_certificado_permanencia"]
    @documento_certificado_permanencia.fecha = fecha_certificado_form  
    @documento_certificado_permanencia.save

    @caso.tipo_control_id = paciente_params[:tipo_control_id]
    @caso.codigo = paciente_params[:codigo]
    @caso.save
    respond_to do |format|
      format.html { redirect_to @paciente, notice: 'Los datos se guardaron correctamente.' }
      format.json { render :show, status: :ok, location: @paciente }
    end
  end  

  # POST /pacientes
  # POST /pacientes.json
  def create
    @paciente = Paciente.new(paciente_params)

    respond_to do |format|
      if @paciente.save
        format.html { redirect_to @paciente, notice: (t 'activerecord.messages.created',model: :paciente) }
        format.json { render :show, status: :created, location: @paciente }
      else
        format.html { render :new }
        format.json { render json: @paciente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pacientes/1
  # PATCH/PUT /pacientes/1.json
  def update
    respond_to do |format|
      if @paciente.update(paciente_params)
        format.html { redirect_to @paciente, notice: (t 'activerecord.messages.updated', model: :paciente) }
        format.json { render :show, status: :ok, location: @paciente }
      else
        format.html { render :edit }
        format.json { render json: @paciente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pacientes/1
  # DELETE /pacientes/1.json
  def destroy
    @paciente.destroy
    respond_to do |format|
      format.html { redirect_to pacientes_url, notice: 'Paciente was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paciente
      @paciente = Paciente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paciente_params
      params.require(:paciente).permit(:nombres, :primer_apellido, :segundo_apellido, :rut, :genero, :fecha_nacimiento, :fono1, :fono2, :email, :direccion, :comuna_id, :tipo_control_id, :codigo, :consentimiento_informado, :fecha_consentimiento_informado, :certificado_permanencia, :fecha_certificado_permanencia)
    end
end
