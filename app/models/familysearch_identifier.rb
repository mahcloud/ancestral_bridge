class FamilysearchIdentifier < ActiveRecord::Base
  attr_accessible :fs_identifier, :person_id

  belongs_to :person
end
