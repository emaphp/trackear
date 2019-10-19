class ProjectContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_project_contract, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /project_contracts
  # GET /project_contracts.json
  def index
    @project_contracts = ProjectContract.all
  end

  # GET /project_contracts/1
  # GET /project_contracts/1.json
  def show
  end

  # GET /project_contracts/new
  def new
    @members = User.all
    @project_contract = @project.project_contracts.new
  end

  # GET /project_contracts/1/edit
  def edit
    @members = User.all
  end

  # POST /project_contracts
  # POST /project_contracts.json
  def create
    @project_contract = @project.project_contracts.new(project_contract_params)

    respond_to do |format|
      if @project_contract.save
        format.html { redirect_to @project_contract.project, notice: 'Project contract was successfully created.' }
        format.json { render :show, status: :created, location: @project_contract.project }
      else
        @members = User.all
        format.html { render :new }
        format.json { render json: @project_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_contracts/1
  # PATCH/PUT /project_contracts/1.json
  def update
    respond_to do |format|
      if @project_contract.update(project_contract_params)
        format.html { redirect_to @project, notice: 'Project contract was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_contracts/1
  # DELETE /project_contracts/1.json
  def destroy
    @project_contract.destroy
    respond_to do |format|
      format.html { redirect_to home_url, notice: 'Project contract was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = current_user.projects.friendly.find(params[:project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project_contract
    @project_contract = @project.project_contracts.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_contract_params
    params.require(:project_contract).permit(
        :user_id,
        :activity,
        :active_from,
        :ends_at,
        :project_rate,
        :user_rate
    )
  end
end
