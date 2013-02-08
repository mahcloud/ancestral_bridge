class Tree < ActiveRecord::Base
  attr_accessible :user_id, :name, :person_id

  belongs_to :user
  has_one :person
  has_many :people

  def getRoot
    return person
  end
end
