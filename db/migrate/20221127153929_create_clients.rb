class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :full_name
      t.string :client_number
      t.string :password_digest

      t.timestamps
    end
  end
end
