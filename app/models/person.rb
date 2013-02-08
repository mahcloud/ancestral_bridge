class Person < ActiveRecord::Base
  attr_accessible :father_id, :gender, :mother_id, :name, :tree_id

  belongs_to :tree
end
