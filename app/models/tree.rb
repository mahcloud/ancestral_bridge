class Tree < ActiveRecord::Base
  attr_accessible :user_id, :name, :person_id

  belongs_to :user
  has_one :person
  has_many :people
  has_many :familysearch_identifiers, :through => :people

  def getRoot
    person = Person.new
    unless person_id.nil?
      person = Person.find(person_id)
    end
    return person
  end
end
