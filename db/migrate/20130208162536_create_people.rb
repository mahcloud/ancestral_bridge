class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :tree_id
      t.string :name
      t.integer :father_id
      t.integer :mother_id
      t.string :gender

      t.timestamps
    end
  end
end
