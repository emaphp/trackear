# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.uniq
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @contracts = @project.project_contracts.currently_active.includes(:user)
    @contract = current_user.currently_active_contract_for(@project)
    @logs_from = logs_from_param
    @logs_to = logs_to_param
    @logs = ActivityTrackService.all_from_range(@project, current_user, @logs_from, @logs_to).includes(:project_contract).order(from: :desc)

    if @project.is_client? current_user
      @invoices = @project.invoices.for_client
    else
      @invoices = @project.invoices.where(user: current_user)
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  # POST /projects.json
  def create
    begin
      @project = current_user.create_project_and_ensure_owner_contract(project_params)
    rescue StandardError
    end

    respond_to do |format|
      if @project.valid? && @project.persisted?
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
    begin
      params[:project][:icon].open
    rescue StandardError
    end
    params.require(:project).permit(:name, :icon)
  end

  def logs_from_param
    Date.parse(logs_params.fetch(:from))
  rescue StandardError
    Date.today.beginning_of_month
  end

  def logs_to_param
    Date.parse(logs_params.fetch(:to))
  rescue StandardError
    Date.today.end_of_month
  end

  def logs_params
    params.fetch(:logs, {})
  end
end
