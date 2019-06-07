class MedicionesController < ApplicationController
  before_action :set_medicion, only: [:show, :edit, :update, :destroy]

  # GET /mediciones
  # GET /mediciones.json
  def index
    @mediciones = Medicion.all
  end

  # GET /mediciones/1
  # GET /mediciones/1.json
  def show
  end

  # GET /mediciones/new
  def new
    @medicion = Medicion.new
  end

  # GET /mediciones/1/edit
  def edit
  end

  # POST /mediciones
  # POST /mediciones.json
  def create
    @medicion = Medicion.new(medicion_params)

    respond_to do |format|
      if @medicion.save
        format.html { redirect_to @medicion, notice: 'Medicion was successfully created.' }
        format.json { render :show, status: :created, location: @medicion }
      else
        format.html { render :new }
        format.json { render json: @medicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mediciones/1
  # PATCH/PUT /mediciones/1.json
  def update
    respond_to do |format|
      if @medicion.update(medicion_params)
        format.html { redirect_to @medicion, notice: 'Medicion was successfully updated.' }
        format.json { render :show, status: :ok, location: @medicion }
      else
        format.html { render :edit }
        format.json { render json: @medicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mediciones/1
  # DELETE /mediciones/1.json
  def destroy
    @medicion.destroy
    respond_to do |format|
      format.html { redirect_to mediciones_url, notice: 'Medicion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medicion
      @medicion = Medicion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medicion_params
      params.require(:medicion).permit(:nombre, :descripcion, :programa_id, :examen_id, :unidad_medida)
    end
end
