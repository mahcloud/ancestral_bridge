class CreateFamilysearchIdentifiers < ActiveRecord::Migration
  def change
    create_table :familysearch_identifiers do |t|
      t.integer :person_id
      t.string :identifier, :unique => true

      t.timestamps
    end
  end
end
