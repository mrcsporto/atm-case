class AccountTransaction < ApplicationRecord
  belongs_to :bank_account

  TRANSACTION_TYPES = ["transfer", "withdraw", "deposit"]

  validates :bank_account, presence: true
  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :transaction_type, presence: true, inclusion: {in: TRANSACTION_TYPES}
  validates :transaction_number, presence: true, uniqueness: true

  before_validation :transaction_uniq_id

  def transaction_uniq_id
    if self.new_record?
      self.transaction_number = SecureRandom.uuid
    end
  end
end
