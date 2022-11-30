class AddDiscardToBankAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :bank_accounts, :discarded_at, :datetime
    add_index :bank_accounts, :discarded_at
  end
end
