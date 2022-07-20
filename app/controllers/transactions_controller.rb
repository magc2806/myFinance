class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_bank_account
  before_action :set_transaction, only: [:new, :create]
  before_action :find_transaction, only: [:edit, :update, :destroy]
  before_action :set_search_params, only: [:index]
  before_action :get_categories, only: [:index,:new, :edit]
  
  def index
    #debugger
    redirect_to bank_account_transactions_path(@bank_account), 
    alert: I18n.t('views.transaction.error_searching.dates') unless Transaction.dates_checking(@min_date, @max_date)
    @transactions = Transaction.includes(:category).search_by_filter(@bank_account.id,@category,@description, @amount, @min_date, @max_date)
    #debugger    
  end

  def new
    
  end

  def create
    respond_to do |format|
      if @transaction.save
        format.turbo_stream do
          flash.now[:notice] = I18n.t('views.common.messages.successful_creation')                   
        end 
        #format.html { redirect_to bank_account_transactions_path, notice: I18n.t('views.common.messages.successful_creation')}                
      else
        flash.now[:alert] = @transaction.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }        
      end    
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.turbo_stream do 
          render turbo_stream: turbo_stream.replace("#{@transaction.id}", partial: "transactions/transaction", locals: {bank_account: @transaction.bank_account, transaction: @transaction})        
        end
        #format.html { redirect_to bank_account_transactions_path(@bank_account), notice: I18n.t('views.common.messages.successful_update')}                
      else
        flash.now[:alert] = @transaction.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
      end    
    end   
  end

  def destroy
    respond_to do |format|
      if @transaction.destroy
        format.turbo_stream
        #format.html { redirect_to bank_account_transactions_path, notice: I18n.t('views.common.messages.successful_destroy') }
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
    params.require(:transaction).permit(:transaction_date,:description, :amount, :category_id)
  end

  def set_transaction       
    @transaction = params[:action] == "new" ? @bank_account.transactions.new : @bank_account.transactions.new(transaction_params)     
  end

  def find_transaction    
    @transaction = @bank_account.transactions.find params[:id]
  end

  def set_search_params    
    @description = params[:filter_description].present? ? params[:filter_description] : nil
    @amount = params[:filter_amount].present? ? params[:filter_amount] : nil
    @min_date = params[:filter_min_date].present? ? params[:filter_min_date] : nil
    @max_date = params[:filter_max_date].present? ? params[:filter_max_date] : nil 
    @category = params[:category].present? ? params[:category].to_i : nil 
           
  end

  def get_categories
    @categories = current_user.categories   
    puts "BUSCANDO CATEGORIAS" 
  end


end
