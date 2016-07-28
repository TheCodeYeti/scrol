class AddMessageIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_id, :string
  end
end
