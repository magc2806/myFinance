class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_bank_account
  before_action :set_transaction, only: [:new, :create]
  before_action :find_transaction, only: [:edit, :update, :destroy]
  before_action :set_search_params, only: [:index, :download_excel, :send_excel]
  before_action :get_categories, only: [:index,:new, :edit]
  before_action :get_transactions, only: [:download_excel, :send_excel]
  
  def index
    
    redirect_to bank_account_transactions_path(@bank_account), 
    alert: I18n.t('views.transaction.error_searching.dates') unless Transaction.dates_checking(@min_date, @max_date)
    get_transactions 
        
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
        get_categories
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
          render turbo_stream: turbo_stream.replace(@transaction, partial: "transactions/transaction", locals: {bank_account: @transaction.bank_account, transaction: @transaction})        
        end
        #format.html { redirect_to bank_account_transactions_path(@bank_account), notice: I18n.t('views.common.messages.successful_update')}                
      else
        flash.now[:alert] = @transaction.errors.full_messages
        get_categories
        format.html { render :edit, status: :unprocessable_entity }
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

  def download_excel
    respond_to do |format|
      format.xlsx do 
        excel_file = Transaction.generate_excel_report(@transactions)
        send_data(excel_file.to_stream.read, filename: I18n.t('reports.transaction.report_file'))
      end
    end
  end

  def send_excel    
    excel_file = Transaction.generate_excel_report(@transactions)
    excel_file = Base64.encode64(excel_file.to_stream.string)
    TransactionMailer.with(user: current_user).excel_report_email(excel_file).deliver_later
    if turbo_frame_request?
      flash.now[:notice]= I18n.t('reports.messages.sent')             
      render partial: "partials/errors", locals: {flash: flash}
    else
      render :index
    end
  end


  private

  def get_bank_account
    if ["destroy", "create"].include?(params[:action])
      @bank_account = BankAccount.includes(:transactions).find(params[:bank_account_id])
      
    else
      @bank_account = BankAccount.find(params[:bank_account_id])    
    end    
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
  end

  def get_transactions
        
    @transactions = Transaction.includes(:category).search_by_filter(@bank_account.id,@category,@description, @amount, @min_date, @max_date)    
  end
end
