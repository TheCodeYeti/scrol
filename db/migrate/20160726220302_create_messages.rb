class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :url
      t.string :type
      t.datetime :timestamp
      t.text :body
      t.string :source

      t.timestamps null: false
    end
  end
end
