class CreateBankAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_accounts do |t|
      t.references :client, null: false, foreign_key: true
      t.decimal :balance, precision: 10, scale: 2
      t.string :account_number

      t.timestamps
    end
  end
end
