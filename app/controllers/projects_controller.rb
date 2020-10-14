# frozen_string_literal: true

class ProjectsController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_user!
  before_action :set_project, only: %i[
    onboarding
    update_rate_from_onboarding
    onboarding_invite_members
    invite_member_from_onboarding
    onboarding_done
    show
    edit
    update
    destroy
    status_period
  ]
  load_and_authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.uniq
  end

  def onboarding; end

  def update_rate_from_onboarding
    contract = current_user.currently_active_contract_for(@project)
    hourly_rate = params.dig(:project_contract, :user_rate)
    contract.project_rate = hourly_rate
    contract.user_rate = hourly_rate
    contract.save
    redirect_to onboarding_invite_members_project_url(@project)
  end

  def onboarding_invite_members
    @project_contract = ProjectContract.new
  end

  def invite_member_from_onboarding
    @project_contract = @project.project_contracts.from_invite(invite_member_params)
    respond_to do |format|
      if @project_contract.save
        format.html { redirect_to onboarding_invite_members_project_url(@project), notice: t(:project_member_invited_from_onboarding) }
      else
        format.html { render :onboarding_invite_members }
      end
    end
  end

  def onboarding_done; end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @stopwatch = current_user.activity_stop_watches.active(@project).first
    @contracts = @project.project_contracts.currently_active.includes(:user)
    @contract = current_user.currently_active_contract_for(@project)
    @logs_from = logs_from_param
    @logs_to = logs_to_param
    @has_logged_today = ActivityTrackService.log_from_today?(@project, current_user)
    @all_logs = ActivityTrackService.all_from_range(@project, current_user, @logs_from, @logs_to)
                                    .includes(:project_contract)
                                    .order(from: :desc)

    @invoice_status = current_user.invoice_status.for_members.for_project(@project).with_news.first

    if @invoice_status.present?
      @invoice_status_logs = ActivityTrackService.all_from_range(@project, current_user, @invoice_status.invoice_status.invoice.from, @invoice_status.invoice_status.invoice.to)
                                                 .includes(:project_contract)
                                                 .order(from: :desc)
    end

    if @project.is_client? current_user
      @invoices = @project.invoices.for_client_visible.paginate(page: 1, per_page: 4)
    else
      @invoices = @project.invoices.where(user: current_user).paginate(page: 1, per_page: 4)
    end

    @logs = @all_logs.paginate(page: params[:page], per_page: 5)

    add_breadcrumb "Projects"
    add_breadcrumb @project.name, @project
  end

  # GET /projects/new
  def new
    @project = Project.new
    add_breadcrumb "Create project", :new_project_path
  end

  # GET /projects/1/edit
  def edit
    add_breadcrumb @project.name, @project
    add_breadcrumb "Edit"
  end

  # POST /projects
  # POST /projects.json
  def create
    begin
      @project = current_user.create_project_and_ensure_owner_contract(project_params)
    rescue StandardError
    end

    respond_to do |format|
      if @project.valid? && @project.persisted?
        format.html { redirect_to onboarding_project_url(@project), notice: t(:project_successfully_created) }
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
        format.html { redirect_to @project, notice: t(:project_successfully_updated) }
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
      format.html { redirect_to home_url, notice: t(:project_successfully_destroyed) }
      format.json { head :no_content }
    end
  end

  def status_period
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    contracts = @project.project_contracts.currently_active.only_team.includes(:user)
    tracks = contracts.map do |contract|
      {
        user: contract.user,
        contract: contract,
        tracks: ActivityTrackService.all_from_range(@project, contract.user, start_date, end_date)
      }
    end

    respond_to do |format|
      format.json { render json: tracks }
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

  def invite_member_params
    params.require(:project_contract).permit(
      :user_email,
      :activity,
      :project_rate,
      :user_rate,
      :user_fixed_rate
    )
  end
end
