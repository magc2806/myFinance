class TransactionMailer < ApplicationMailer

  def excel_report_email excel    
    @user = params[:user]
    attachment = excel
    attachments[I18n.t('reports.transaction.report_file')] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(to: @user.email, subject: 'Reporte de transacciones')  
  end
  
  def hello_email    
    @user = params[:user]
    mail(to: @user.email, subject: 'Reporte de transacciones')  
  end

=begin
  def excel_report_email excel
    transactions = Transaction.where id: transactions_ids
    
    @user = params[:user]
    xlsx = render_to_string layout: false, handlers: [:axlsx], formats: [:xlsx], template: "transactions/transactions", locals: {transactions: transactions}
    attachment = Base64.encode64(xlsx)
    attachments["transactions.xlsx"] = {mime_type: Mime[:xlsx], content: attachment, encoding: 'base64'}
    mail(to: @user.email, subject: 'Reporte de transacciones')  
  end
=end

end
