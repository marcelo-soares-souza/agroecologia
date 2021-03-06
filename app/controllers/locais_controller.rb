class LocaisController < ApplicationController
  before_action :set_local, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!, only: [:new, :edit, :update, :destroy]
  before_action -> { check_owner Local.friendly.find(params[:id]).usuario_id }, only: [:edit, :update, :destroy]
  before_action :load_tipos, except: [:index, :show]
  before_action :load_hospedagens, except: [:index, :show]
  before_action :load_usuario
  before_action :load_colaboradores, only: [:new, :edit, :update]

  # GET /locais
  # GET /locais.json
  def index
    if params[:usuario_id]
      @locais = Local.where(:usuario_id => @usuario.id).sort_by(&:updated_at).reverse
    else
      @locais = Local.all.sort_by(&:updated_at).reverse
    end
  end

  # GET /locais/1
  # GET /locais/1.json
  def show
  end

  # GET /locais/new
  def new
    @local = Local.new
    @local.local_usuarios.build
  end

  # GET /locais/1/edit
  def edit
    @local.local_usuarios.build
  end

  # POST /locais
  # POST /locais.json
  def create
    @local = Local.new(local_params)

    if !current_usuario.admin?
      @local.usuario_id = current_usuario.id
    end

    respond_to do |format|
      if @local.save
        format.html { redirect_to @local, notice: 'Local foi cadastrado.' }
        format.json { render :show, status: :created, location: @local }
      else
        format.html { render :new }
        format.json { render json: @local.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locais/1
  # PATCH/PUT /locais/1.json
  def update
    respond_to do |format|
      if @local.update(local_params)
        format.html { redirect_to @local, notice: 'Local foi atualizado.' }
        format.json { render :show, status: :ok, location: @local }
      else
        format.html { render :edit }
        format.json { render json: @local.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locais/1
  # DELETE /locais/1.json
  def destroy
    @local.destroy
    respond_to do |format|
      format.html { redirect_to locais_url, notice: 'Local foi removido.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_local
    @local = Local.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def local_params
    params.require(:local).permit(:nome, :slug, :observacao, :latitude, :longitude, :usuario_id, :imagem, :tipo, :hospedagem, :usuario_ids => [])
  end

  def load_tipos
    @tipos = { "Assentamento" => "Assentamento",
               "Propriedade Coletiva" => "Propriedade Coletiva",
               "Propriedade Pública (Governo)" => "Propriedade Pública (Governo)",
               "Propriedade Privada" => "Propriedade Privada",
               "Familiar" => "Familiar",
               "Outro" => "Outro" }
  end

  def load_hospedagens
    @hospedagens = { "Mediante a Consulta" => "Mediante a Consulta",
                     "Sim" => "Sim",
                     "Não" => "Não" }
  end

  def load_colaboradores
    @usuarios = Usuario.all
  end

  def load_usuario
    if params[:usuario_id]
      @usuario = Usuario.friendly.find(params[:usuario_id])
    end
  end
end
