# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_invoice, only: %i[show edit update destroy email_notify make_visible hide download_invoice download_payment review_entries upload_invoice upload_payment]
  load_and_authorize_resource

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = if current_user.is_admin?
                  @project.invoices.includes(:user).order(from: :desc)
                elsif @project.is_client? current_user 
                  @project.invoices.includes(:user).for_client.order(from: :desc)
                else
                  current_user.invoices.includes(:user).where(project: @project).order(from: :desc)
                end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show; end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.discount_percentage = 0
    @invoice.from = Date.today.beginning_of_month
    @invoice.to = Date.today.end_of_month
  end

  # GET /invoices/1/edit
  def edit; end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = @project.invoices.new(invoice_params)
    @invoice.user = current_user

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(update_invoice_params)
        format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def email_notify
    InvoiceMailer.invoice_notify(@invoice).deliver
    respond_to do |format|
      format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Email notification sent.' }
      format.json { render :show, status: :ok, location: project_invoice_path(@project, @invoice) }
    end
  end

  def make_internal
    @invoice.is_client_visible = false
    @invoice.save

    respond_to do |format|
      format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice is now internal.' }
      format.json { render :show, status: :ok, location: project_invoice_path(@project, @invoice) }
    end
  end

  def make_client
    @invoice.is_client_visible = true
    @invoice.save

    respond_to do |format|
      format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice is now a client invoice.' }
      format.json { render :show, status: :ok, location: project_invoice_path(@project, @invoice) }
    end
  end

  def make_visible
    @invoice.is_visible = true
    @invoice.save

    respond_to do |format|
      format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice is visible.' }
      format.json { render :show, status: :ok, location: project_invoice_path(@project, @invoice) }
    end
  end

  def hide
    @invoice.is_visible = false
    @invoice.save

    respond_to do |format|
      format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice is no longer visible.' }
      format.json { render :show, status: :ok, location: project_invoice_path(@project, @invoice) }
    end
  end

  def download_invoice
    name = @invoice.project.name + " - " + @invoice.from.strftime("%B %Y")
    send_data @invoice.invoice.download.read, filename: name + '.pdf', type: 'application/pdf'
  end

  def download_payment
    name = @invoice.project.name + " - Payment - " + @invoice.from.strftime("%B %Y")
    send_data @invoice.payment.download.read, filename: name + '.pdf', type: 'application/pdf'
  end

  def review_entries; end

  def upload_invoice
    respond_to do |format|
      if @invoice.update(upload_invoice_params)
        format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice attached successfully.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_payment
    respond_to do |format|
      if @invoice.update(upload_payment_params)
        format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Payment receipt attached successfully.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_project
    @project = current_user.projects.friendly.find(params[:project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    to_be_included = [
      {
        activity_track: [
          {
            project_contract: [:user]
          }
        ]
      }
    ]
    if current_user.is_admin?
      @invoice = Invoice.includes(invoice_entries: to_be_included).find(params[:id])
    elsif @project.is_client? current_user
      @invoice = @project.invoices.includes(invoice_entries: to_be_included).for_client.find(params[:id])
    else
      @invoice = current_user.invoices.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invoice_params
    params.require(:invoice).permit(
      :currency,
      :discount_percentage,
      :from,
      :to
    )
  end

  def update_invoice_params
    if current_user.is_admin?
      params.require(:invoice).permit(
        :currency,
        :is_client_visible,
        :discount_percentage,
        invoice_entries_attributes: %i[id description rate from to]
      )
    else
      params.require(:invoice).permit(
        :currency,
        :discount_percentage,
      )
    end
  end

  def upload_invoice_params
    begin
      params[:invoice][:invoice].open
    rescue StandardError
    end
    params.require(:invoice).permit(:invoice)
  end

  def upload_payment_params
    begin
      params[:invoice][:payment].open
    rescue StandardError
    end
    params.require(:invoice).permit(:payment)
  end
end
