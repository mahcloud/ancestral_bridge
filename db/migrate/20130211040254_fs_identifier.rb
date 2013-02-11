class FsIdentifier < ActiveRecord::Migration
  def up
    rename_column :familysearch_identifiers, :identifier, :fs_identifier
  end

  def down
    rename_column :familysearch_identifiers, :fs_identifier, :identifier
  end
end
