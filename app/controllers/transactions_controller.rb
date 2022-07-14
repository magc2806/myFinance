class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_bank_account
  before_action :set_transaction, only: [:new, :create]
  before_action :find_transaction, only: [:edit, :update, :destroy]

  def index
    
    @transactions = @bank_account.transactions.order(:transaction_date)
    
  end

  def new
    
  end

  def create

    respond_to do |format|


      if @transaction.save
        format.html { redirect_to bank_account_transactions_path, notice: I18n.t('views.common.messages.successful_creation')}
                
      else
        flash[:alert] = @transaction.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }        
      end    
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to bank_account_transactions_path(@bank_account), notice: I18n.t('views.common.messages.successful_update')}
                
      else
        flash[:alert] = @transaction.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
      end    
    end

    
  end

  def destroy
    respond_to do |format|
      if @transaction.destroy
        format.html { redirect_to bank_account_transactions_path, notice: I18n.t('views.common.messages.successful_destroy') }
      else
        flash[:alert] = @transaction.errors.full_messages
        format.html { render :index, status: :unprocessable_entity }
      end
    end    
  end


  private

  def get_bank_account
    @bank_account = BankAccount.find(params[:bank_account_id])
    
  end

  def transaction_params    
    params.require(:transaction).permit(:transaction_date,:description, :amount)

  end

  def set_transaction
       
    @transaction = params[:action] == "new" ? @bank_account.transactions.new : @bank_account.transactions.new(transaction_params) 
    
  end

  def find_transaction
    
    get_bank_account
    @transaction = @bank_account.transactions.find params[:id]

  end


end
