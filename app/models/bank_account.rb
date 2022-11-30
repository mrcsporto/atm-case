class BankAccount < ApplicationRecord
  belongs_to :client
  has_many :account_transactions

  validates :client, presence: true
  validates :account_number, presence: true, uniqueness: true, length: { is: 6 }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: BigDecimal(10**3) },
                      format: { with: /\A\d{1,3}(\.\d{1,2})?\z/ }

  before_validation :new_account
  
  paginates_per 5

  include Discard::Model

  def new_account
    if new_record?
      self.balance = 0.00
      self.account_number = (SecureRandom.random_number(6e5) + 1e5).to_i.to_s
    end
  end
end
