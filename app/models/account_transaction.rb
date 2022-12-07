class AccountTransaction < ApplicationRecord
  belongs_to :bank_account

  TRANSACTION_TYPES = %i[Transfer Withdraw Deposit]

  validates :bank_account, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :transaction_number, presence: true, uniqueness: true
  # validates :receiver_id, presence: true, if: -> { (transaction_type.eql? 'Transfer') }

  before_validation :transaction_uniq_id
  before_save :upcase_transaction_type
  before_save :set_amount

  paginates_per 8

  def upcase_transaction_type
    self.transaction_type = transaction_type.upcase
  end

  def set_amount
    amount.to_f
  end

  def transaction_uniq_id
    self.transaction_number = SecureRandom.uuid if new_record?
  end
end
