class AddCpfToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :cpf, :string
  end
end
