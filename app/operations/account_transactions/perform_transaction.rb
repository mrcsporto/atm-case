module AccountTransactions
  class PerformTransaction
    def initialize(amount:, transaction_type:, bank_account_id:, receiver_id:)
      @amount = amount.try(:to_f)
      @transaction_type = transaction_type
      @bank_account_id = bank_account_id
      @receiver_id = receiver_id
      @bank_account = BankAccount.where(id: bank_account_id).first
      @receiver_account = BankAccount.where(account_number: receiver_id).first
    end

    def create_transaction!(bank_account, amount, transaction_type, receiver_id)
      AccountTransaction.create!(
        bank_account: bank_account,
        amount: amount,
        transaction_type: transaction_type,
        receiver_id: receiver_id
      )
      bank_account.update(balance: bank_account.balance - amount) if transaction_type == 'Withdraw'
      bank_account.update(balance: bank_account.balance + amount) if transaction_type == 'Deposit'
      raise ActiveRecord::Rollback unless bank_account.present?
    end

    def execute!
      if %w[Withdraw Deposit].include?(@transaction_type)
        ActiveRecord::Base.transaction do
          create_transaction!(@bank_account, @amount, @transaction_type, @receiver_id)
        end
      elsif @transaction_type.eql? 'transfer'
        ActiveRecord::Base.transaction do
          create_transaction!(@bank_account, @amount, 'Withdraw', @receiver_id)
          create_transaction!(@receiver_account, @amount, 'Deposit', @bank_account.account_numbers)
        end
      end
      @bank_account
    end
  end
end
