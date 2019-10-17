class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.uniq
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @contracts = @project.project_contracts.currently_active
    @contract = current_user.currently_active_contract_for(@project)
    @logs_from = logs_from_param
    @logs_to = logs_to_param
    @logs = @contract.activity_tracks.where(from: @logs_from..@logs_to + 1.day)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @contract = current_user.create_owner_contract_for(@project)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to home_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = current_user.projects.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name)
  end

  def logs_from_param
    Date.parse(logs_params.fetch(:from)) rescue Date.today.beginning_of_month
  end

  def logs_to_param
    Date.parse(logs_params.fetch(:to)) rescue Date.today.end_of_month
  end

  def logs_params
    params.fetch(:logs, {})
  end
end
