class ProgramasController < ApplicationController
  before_action :set_laboratorio
  before_action :set_programa, only: [:show, :edit, :update, :destroy]

  # GET laboratorios/1/programas
  def index
    @programas = @laboratorio.programas
  end

  # GET laboratorios/1/programas/1
  def show
    @documento = @programa.documento_programas
    @examen = @programa.examen_programas
    @medicamento = @programa.medicamento_programas
    @mediciones= @programa.mediciones
    @alarmas = @programa.mediciones.first.alarmas
  end

  # GET laboratorios/1/programas/new
  def new
    @programa = @laboratorio.programas.build
  end

  # GET laboratorios/1/programas/1/edit
  def edit
  end

  # POST laboratorios/1/programas
  def create
    @programa = @laboratorio.programas.build(programa_params)

    if @programa.save
      redirect_to([@programa.laboratorio, @programa], notice: 'Programa was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT laboratorios/1/programas/1
  def update
    if @programa.update_attributes(programa_params)
      redirect_to([@programa.laboratorio, @programa], notice: 'Programa was successfully updated.')
    else
      render action: 'edit'
    end
  end

  # DELETE laboratorios/1/programas/1
  def destroy
    @programa.destroy

    redirect_to laboratorio_programas_url(@laboratorio)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laboratorio
      @laboratorio = Laboratorio.find(params[:laboratorio_id])
    end

    def set_programa
      @programa = @laboratorio.programas.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def programa_params
      params.require(:programa).permit(:nombre, :descripcion, :fecha_creacion, :qf_soporte_id)
    end
end
