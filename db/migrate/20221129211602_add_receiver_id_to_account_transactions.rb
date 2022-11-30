class AddReceiverIdToAccountTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :account_transactions, :receiver_id, :string
  end
end
