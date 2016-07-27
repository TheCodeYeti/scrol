class SorceryExternal < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id, :null => false
      t.string :provider, :uid, :null => false
      t.string :oauth_token, :oauth_secret

      t.timestamps
    end

    add_index :authentications, [:provider, :uid]
  end
end
