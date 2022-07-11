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
        format.json { render bank_accounts_path, status: :created, location: @bank_account }        
      else
        flash[:alert] = @bank_account.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end    
    end

    
  end

  def update
    
  end

  def destroy
    
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
