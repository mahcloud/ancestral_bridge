class Tree < ActiveRecord::Base
  attr_accessible :user_id, :name, :person_id

  belongs_to :user
end
