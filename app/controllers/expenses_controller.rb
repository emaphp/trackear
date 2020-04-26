class ExpensesController < ApplicationController
  before_action :authenticate_user!, except: [:accept_invitation]

  before_action :set_expense, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :download
  ]

  # GET /expenses
  # GET /expenses.json
  def index
    from = from_param
    to = to_param
    page = params[:page]

    @invitation_id = params[:invitation]
    @expenses_invited_to = ExpenseInvitationService.get_list_from_user(current_user)

    if (@invitation_id.nil?)
      @all_expenses = current_user.expenses.in_period(from, to)
    else
      @invitation = ExpenseInvitation.where(id: @invitation_id, email: current_user.email, status: 'accepted').first
      @all_expenses = Expense.where(user_id: @invitation.user_id).in_period(from, to)
    end
    @expenses = @all_expenses.paginate(page: page, per_page: 10)
    @invitations = current_user.expense_invitations
    
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
    @expense = current_user.expenses.new(expense_params)

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

  def send_invitation
    invitation = current_user.expense_invitations.new(expense_invitation_params)
    invitation.save

    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Invitation sent successfully.' }
      format.json { head :no_content }
    end
  end

  def accept_invitation
    @invitation = ExpenseInvitation.find_by(token: params[:token])
    @invitation.accept
    @invitation.save
    User.where(email: @invitation.email).first_or_create
    redirect_to home_url, notice: 'The invitation was accepted, please log in with your Google account'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = current_user.expenses.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(
        :name,
        :price,
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

    def expense_invitation_params
      params.require(:expense_invitation).permit(
        :name,
        :email
      )
    end
end
