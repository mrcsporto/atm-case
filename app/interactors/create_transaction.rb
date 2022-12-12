class CreateTransaction
  include Interactor

  def call
    transaction_type = context.params[:transaction_type]
    bank_account = BankAccount.find(context.params[:bank_account_id])
    amount = context.params[:amount].to_f
    balance = BankAccount.find(context.params[:bank_account_id]).balance.to_f
    context.account_transaction = AccountTransaction.new(context.params)
    context.account_transaction.save

    if transaction_type == 'Withdraw' && bank_account.balance >= amount
      BankAccount.update(bank_account.id, balance: balance - amount)

    elsif transaction_type == 'Deposit' && amount.positive?
      BankAccount.update(bank_account.id, balance: balance + amount)

    elsif transaction_type == 'Transfer' && bank_account.balance - amount >= 0.00
      receiver_account = BankAccount.find(context.params[:receiver_id]) unless receiver_account.present?
      BankAccount.update(bank_account.id, balance: balance - amount)
      BankAccount.update(receiver_account.id, balance: receiver_account.balance.to_f + amount)
    else
      context.fail!
    end
  end
end
