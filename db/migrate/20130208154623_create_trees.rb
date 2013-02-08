class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.integer :person_id

      t.timestamps
    end
  end
end
