class FarmaciasController < ApplicationController
  before_action :set_farmacia, only: [:show, :edit, :update, :destroy]

  # GET /farmacias
  # GET /farmacias.json
  def index
    @query = Farmacia.ransack(params[:q])
    @farmacias = @query.result.includes(:comuna).page(params[:page])
  end

  # GET /farmacias/1
  # GET /farmacias/1.json
  def show
  end

  # GET /farmacias/new
  def new
    @farmacia = Farmacia.new
  end

  # GET /farmacias/1/edit
  def edit
  end

  # POST /farmacias
  # POST /farmacias.json
  def create
    @farmacia = Farmacia.new(farmacia_params)

    respond_to do |format|
      if @farmacia.save
        format.html { redirect_to @farmacia, notice: 'Farmacia was successfully created.' }
        format.json { render :show, status: :created, location: @farmacia }
      else
        format.html { render :new }
        format.json { render json: @farmacia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /farmacias/1
  # PATCH/PUT /farmacias/1.json
  def update
    respond_to do |format|
      if @farmacia.update(farmacia_params)
        format.html { redirect_to @farmacia, notice: 'Farmacia was successfully updated.' }
        format.json { render :show, status: :ok, location: @farmacia }
      else
        format.html { render :edit }
        format.json { render json: @farmacia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /farmacias/1
  # DELETE /farmacias/1.json
  def destroy
    @farmacia.destroy
    respond_to do |format|
      format.html { redirect_to farmacias_url, notice: 'Farmacia was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_farmacia
      @farmacia = Farmacia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def farmacia_params
      params.require(:farmacia).permit(:nombre, :contacto, :fono, :direccion, :comuna_id, :tipo)
    end
end
