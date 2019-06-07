class ExamenesController < ApplicationController
  before_action :set_examen, only: [:show, :edit, :update, :destroy]

  # GET /examenes
  # GET /examenes.json
  def index
    @examenes = Examen.all
  end

  # GET /examenes/1
  # GET /examenes/1.json
  def show
  end

  # GET /examenes/new
  def new
    @examen = Examen.new
  end

  # GET /examenes/1/edit
  def edit
  end

  # POST /examenes
  # POST /examenes.json
  def create
    @examen = Examen.new(examen_params)

    respond_to do |format|
      if @examen.save
        format.html { redirect_to @examen, notice: 'Examen was successfully created.' }
        format.json { render :show, status: :created, location: @examen }
      else
        format.html { render :new }
        format.json { render json: @examen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examenes/1
  # PATCH/PUT /examenes/1.json
  def update
    respond_to do |format|
      if @examen.update(examen_params)
        format.html { redirect_to @examen, notice: 'Examen was successfully updated.' }
        format.json { render :show, status: :ok, location: @examen }
      else
        format.html { render :edit }
        format.json { render json: @examen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examenes/1
  # DELETE /examenes/1.json
  def destroy
    @examen.destroy
    respond_to do |format|
      format.html { redirect_to examenes_url, notice: 'Examen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examen
      @examen = Examen.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def examen_params
      params.require(:examen).permit(:nombre, :descripcion)
    end
end
