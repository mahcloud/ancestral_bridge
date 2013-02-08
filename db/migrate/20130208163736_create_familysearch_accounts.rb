class CreateFamilysearchAccounts < ActiveRecord::Migration
  def change
    create_table :familysearch_accounts do |t|
      t.integer :user_id, :null => false, :unique => true
      t.string :username, :null => false
      t.string :password, :null => false
      t.string :session_id, :null => true
      t.timestamp :session_update, :null => true

      t.timestamps
    end
  end
end
