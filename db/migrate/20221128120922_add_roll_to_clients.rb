class AddRollToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :role, :string
  end
end
