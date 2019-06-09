class RecomendacionesController < ApplicationController
  before_action :set_recomendacion, only: [:show, :edit, :update, :destroy]

  # GET /recomendaciones
  # GET /recomendaciones.json
  def index
    @recomendaciones = Recomendacion.all
  end

  # GET /recomendaciones/1
  # GET /recomendaciones/1.json
  def show
  end

  # GET /recomendaciones/new
  def new
    @recomendacion = Recomendacion.new
  end

  # GET /recomendaciones/1/edit
  def edit
  end

  # POST /recomendaciones
  # POST /recomendaciones.json
  def create
    @recomendacion = Recomendacion.new(recomendacion_params)

    respond_to do |format|
      if @recomendacion.save
        format.html { redirect_to @recomendacion, notice: 'Recomendacion was successfully created.' }
        format.json { render :show, status: :created, location: @recomendacion }
      else
        format.html { render :new }
        format.json { render json: @recomendacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recomendaciones/1
  # PATCH/PUT /recomendaciones/1.json
  def update
    respond_to do |format|
      if @recomendacion.update(recomendacion_params)
        format.html { redirect_to @recomendacion, notice: 'Recomendacion was successfully updated.' }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_recomendacion
      @recomendacion = Recomendacion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recomendacion_params
      params.require(:recomendacion).permit(:id_recomendacion, :estado, :resultado, :caso_id, :programa_id, :paciente_id, :medico_id, :prestador_id, :farmacia_id, :qf_soporte_id, :ejecutivo_id, :fecha_hora_ingreso, :via_ingreso, :fecha_hora_respuesta, :observaciones, :con_alarma)
    end
end
