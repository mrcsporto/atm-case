module AccountTransactions
  class ValidateNewTransaction
    def initialize(amount:, transaction_type:, bank_account_id:, receiver_id:)
      @amount = amount.try(:to_f)
      @transaction_type = transaction_type
      @bank_account_id = bank_account_id
      @receiver_id = receiver_id
      @bank_account = BankAccount.where(id: @bank_account_id).first
      @receiver_account = BankAccount.where(account_number: @receiver_id).first
      @errors = []
    end

    def execute!
      validate_existence_of_account!
      validate_transaction! if account_present && transaction_deduction
      @errors
    end

    private

    def validate_transaction!
      @errors << 'Not enough funds' if @bank_account.balance - @amount < 0.00
    end

    def account_present
      @bank_account.present? && @receiver_account.present?
    end

    def transaction_deduction
      %w[Withdraw Transfer].include?(@transaction_type)
    end

    def validate_existence_of_account!
      @errors << 'Account not found' if @bank_account.blank?
      @errors << 'Receiver Account not found' if @receiver_account.blank?
    end
  end
end
