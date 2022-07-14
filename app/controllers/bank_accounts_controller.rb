class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_bank_account, only: %i[edit update destroy ]
  before_action :set_bank_account, only: %i[create]


  def index
    @bank_accounts = current_user.bank_accounts
    
  end

  def new
    @bank_account = current_user.bank_accounts.new    
  end

  def create

    respond_to do |format|
      if @bank_account.save
        format.html { redirect_to bank_accounts_path, notice: I18n.t('views.common.messages.successful_creation')}
                
      else
        flash[:alert] = @bank_account.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }        
      end    
    end

    
  end

  def edit
    
  end


  def update
    respond_to do |format|
      if @bank_account.update(bank_account_params)
        format.html { redirect_to bank_accounts_path, notice: I18n.t('views.common.messages.successful_update') }        
      else
        flash[:alert] = @bank_account.errors.full_messages
        format.html { render :edit, status: :unprocessable_entity }        
      end
    end    
  end

  def destroy
    respond_to do |format|
      if @bank_account.update(active: false)
        format.html { redirect_to bank_accounts_path, notice: I18n.t('views.common.messages.successful_destroy') }
      else
        flash[:alert] = @bank_account.errors.full_messages
        format.html { render :index, status: :unprocessable_entity }
      end
    end    
  end

  private

  def find_bank_account
    @bank_account = current_user.bank_accounts.find(params[:id])

  end

  def set_bank_account
    @bank_account = current_user.bank_accounts.new(bank_account_params)

  end

  def bank_account_params

    params.require(:bank_account).permit(:name,:account_number, :bank_name)
    
  end

end
