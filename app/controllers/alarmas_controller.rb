class AlarmasController < ApplicationController
  before_action :set_medicion
  before_action :set_alarma, only: [:show, :edit, :update, :destroy]

  # GET mediciones/1/alarmas
  def index
    @alarmas = @medicion.alarmas
  end

  # GET mediciones/1/alarmas/1
  def show
  end

  # GET mediciones/1/alarmas/new
  def new
    @alarma = @medicion.alarmas.build
  end

  # GET mediciones/1/alarmas/1/edit
  def edit
  end

  # POST mediciones/1/alarmas
  def create
    @alarma = @medicion.alarmas.build(alarma_params)

    if @alarma.save
      redirect_to([@alarma.medicion, @alarma], notice: 'Alarma was successfully created.')
    else
      render action: 'new'
    end
  end

  # PUT mediciones/1/alarmas/1
  def update
    if @alarma.update_attributes(alarma_params)
      redirect_to([@alarma.medicion, @alarma], notice: 'Alarma was successfully updated.')
    else
      render action: 'edit'
    end
  end

  # DELETE mediciones/1/alarmas/1
  def destroy
    @alarma.destroy

    redirect_to medicion_alarmas_url(@medicion)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medicion
      @medicion = Medicion.find(params[:medicion_id])
    end

    def set_alarma
      @alarma = @medicion.alarmas.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def alarma_params
      params.require(:alarma).permit(:nombre, :valor_minimo, :valor_maximo, :accion, :resultado, :observaciones)
    end
end
