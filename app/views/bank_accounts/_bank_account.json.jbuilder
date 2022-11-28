json.extract! bank_account, :id, :client_id, :balance, :account_number, :created_at, :updated_at
json.url bank_account_url(bank_account, format: :json)
