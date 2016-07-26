class AuthenticationsAddUserInfo < ActiveRecord::Migration
  def change
    add_column :authentications, :email, :string
    add_column :authentications, :username, :string
  end
end
