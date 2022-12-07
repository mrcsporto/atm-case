class CreateTransaction
  include Interactor

  def call
    transaction_type = context.params[:transaction_type]
    bank_account = BankAccount.find(context.params[:bank_account_id])
    amount = context.params[:amount].to_f
    balance = BankAccount.find(context.params[:bank_account_id]).balance.to_f
    receiver_account = BankAccount.find(context.params[:receiver_id]) if receiver_account.nil?
    
    context.account_transaction = AccountTransaction.new(context.params)
    
 
    if transaction_type == 'Withdraw' && bank_account.balance >= amount
      context.account_transaction.save
      BankAccount.update(bank_account.id, balance: balance - amount)
    elsif transaction_type == 'Deposit' && amount.positive?
      context.account_transaction.save
      BankAccount.update(bank_account.id, balance: balance + amount)
    elsif transaction_type == 'Transfer' && bank_account.balance - amount >= 0.00
      context.account_transaction.save
      BankAccount.update(bank_account.id, balance: balance - amount)
      BankAccount.update(receiver_account.id, balance: receiver_account.balance.to_f + amount)
    else
      context.fail!
    end
  end
end
