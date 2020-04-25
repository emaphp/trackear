class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy, :download]

  # GET /expenses
  # GET /expenses.json
  def index
    from = from_param
    to = to_param
    page = params[:page]
    @all_expenses = Expense.in_period(from, to)
    @expenses = @all_expenses.paginate(page: page, per_page: 10)
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    receipt = @expense.receipt
    metadata = receipt.metadata
    name = @expense.name + ' ' + @expense.from.strftime("%B %Y") + ' - ' + metadata['filename']
    mime_type = metadata['mime_type']
    send_data @expense.receipt.download.read, filename: name, type: mime_type
  rescue StandardError
    redirect_to expenses_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(
        :name,
        :price_cents,
        :receipt,
        :from,
        :project_id
      )
    end

    def from_param
      Date.parse(params.fetch(:from))
    rescue StandardError
      Date.today.beginning_of_month
    end
  
    def to_param
      Date.parse(params.fetch(:to))
    rescue StandardError
      Date.today.end_of_month
    end
end
