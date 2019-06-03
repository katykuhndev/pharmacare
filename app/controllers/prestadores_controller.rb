class PrestadoresController < ApplicationController
  before_action :set_prestador, only: [:show, :edit, :update, :destroy]

  # GET /prestadores
  # GET /prestadores.json
  def index
    @query = Prestador.ransack(params[:q])
    @prestadores = @query.result.includes(:comuna).page(params[:page])
  end

  # GET /prestadores/1
  # GET /prestadores/1.json
  def show
  end

  # GET /prestadores/new
  def new
    @prestador = Prestador.new
  end

  # GET /prestadores/1/edit
  def edit
  end

  # POST /prestadores
  # POST /prestadores.json
  def create
    @prestador = Prestador.new(prestador_params)

    respond_to do |format|
      if @prestador.save
        format.html { redirect_to @prestador, notice: 'Prestador was successfully created.' }
        format.json { render :show, status: :created, location: @prestador }
      else
        format.html { render :new }
        format.json { render json: @prestador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prestadores/1
  # PATCH/PUT /prestadores/1.json
  def update
    respond_to do |format|
      if @prestador.update(prestador_params)
        format.html { redirect_to @prestador, notice: 'Prestador was successfully updated.' }
        format.json { render :show, status: :ok, location: @prestador }
      else
        format.html { render :edit }
        format.json { render json: @prestador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestadores/1
  # DELETE /prestadores/1.json
  def destroy
    @prestador.destroy
    respond_to do |format|
      format.html { redirect_to prestadores_url, notice: 'Prestador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prestador
      @prestador = Prestador.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prestador_params
      params.require(:prestador).permit(:nombre, :contacto, :fono, :direccion, :comuna_id)
    end
end
