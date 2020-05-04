# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_report, only: %i[show edit update destroy]

  # GET /reports
  # GET /reports.json
  def index
    @reports = @project.reports
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @invoices = @project.invoices.in_range(@report.from, @report.to)
    @client_invoices = @project.invoices.in_range(@report.from, @report.to).for_client
  end

  # GET /reports/new
  def new
    @users = User.all
    @report = @project.reports.new(
      user: current_user,
      from: Date.today.beginning_of_month,
      to: Date.today.end_of_month
    )
  end

  # GET /reports/1/edit
  def edit
    @users = User.all
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = @project.reports.new(report_params)
    @report.user = current_user

    respond_to do |format|
      if @report.save
        format.html { redirect_to [@project, @report], notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update!(report_params)
        format.html { redirect_to [@project, @report], notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = @project.reports.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params
      .require(:report)
      .permit(
        :from,
        :to,
        :user_id,
        :project_id,
        :invoice_id,
        report_worker_entries_attributes: %i[id user_id invoice_id _destroy],
        report_partner_entries_attributes: %i[id user_id percentage _destroy]
      )
  end
end
