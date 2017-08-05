class OrganizacoesController < ApplicationController
  before_action :set_organizacao, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!, only: [:new, :edit, :update, :destroy]
  before_action only: [:edit, :update, :destroy] { check_owner Organizacao.friendly.find(params[:id]).organizacao.user_id }
  before_action :load_tipo_organizacoes, except: [:index]
  before_action :load_ufs, except: [:index]

  # GET /organizacoes
  # GET /organizacoes.json
  def index
    @organizacoes = Organizacao.all
  end

  # GET /organizacoes/1
  # GET /organizacoes/1.json
  def show
  end

  # GET /organizacoes/new
  def new
    @organizacao = Organizacao.new
  end

  # GET /organizacoes/1/edit
  def edit
  end

  # POST /organizacoes
  # POST /organizacoes.json
  def create
    @organizacao = Organizacao.new(organizacao_params)
    @organizacao.usuario_id = current_usuario.id

    respond_to do |format|
      if @organizacao.save
        format.html { redirect_to @organizacao, notice: 'Organizacao was successfully created.' }
        format.json { render :show, status: :created, location: @organizacao }
      else
        format.html { render :new }
        format.json { render json: @organizacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizacoes/1
  # PATCH/PUT /organizacoes/1.json
  def update
    respond_to do |format|
      if @organizacao.update(organizacao_params)
        format.html { redirect_to @organizacao, notice: 'Organizacao was successfully updated.' }
        format.json { render :show, status: :ok, location: @organizacao }
      else
        format.html { render :edit }
        format.json { render json: @organizacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizacoes/1
  # DELETE /organizacoes/1.json
  def destroy
    @organizacao.destroy
    respond_to do |format|
      format.html { redirect_to organizacoes_url, notice: 'Organizacao was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organizacao
      @organizacao = Organizacao.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organizacao_params
      params.require(:organizacao).permit(:nome, :slug, :sigla, :tipo_organizacao_id, :email, :telefone, :site, :descricao, :cidade, :uf, :pais, :latitude, :longitude, :observacao, :usuario_id)
    end

    def load_tipo_organizacoes
      @tipo_organizacoes = TipoOrganizacao.all
    end

end