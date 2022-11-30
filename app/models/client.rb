class Client < ApplicationRecord
  validates :full_name, format: { with: /\A[\p{Latin}\s-]{2,50}\z/i,
    message: "only allows letters" }
  validates :client_number, presence: true, uniqueness: true, length: { is: 6 }
  validates :cpf, presence: true, uniqueness: true, numericality: { only_integer: true, 
    message: "symbols are NOT allowed (insert only numbers)"  }
  validates :password, length: { in: 3..20 }
  validate :cpf_valid?
  
  ROLES = %w[admin client]
  
  has_secure_password
  
  has_many :bank_accounts
  
  before_save :upcase_full_name
  before_validation :new_client
  before_create :first_user_admin
  
  
  def upcase_full_name
    self.full_name = self.full_name.upcase
  end

  def new_client
    if self.new_record?
      self.client_number = ((SecureRandom.random_number(9e5) + 1e5).to_i).to_s
      self.role = "client"
    end
  end

  def first_user_admin
    self.role = "admin" if Client.count == 0
  end

  def cpf_valid?
    return if CPF.valid?(cpf)
    errors.add(:cpf)
  end

  def role_symbols
    [role.to_sym]
  end
end
