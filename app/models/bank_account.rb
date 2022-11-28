class BankAccount < ApplicationRecord
  belongs_to :client
  has_many :account_transactions

  validates :client, presence: true
  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true,  numericality: {greater_than_or_equal_to: 0}

  before_validation :new_account

  def new_account
    if self.new_record?
      self.balance = 0.00
      self.account_number = ((SecureRandom.random_number(6e5) + 1e5).to_i).to_s
    end
  end
end
