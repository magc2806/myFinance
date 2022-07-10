class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_bank_account, only: %i[edit update destroy ]


  def index
    
  end

  def find_bank_account
    @bank_account = BankAccount.find(params[:id])
        
  end

end
