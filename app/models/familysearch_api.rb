require 'rubygems'
require 'ruby-fs-stack'
require 'logger'

class FamilysearchApi
  LOGIN_URL = "/identity/v2/login"
  PERSON_URL = "/familytree/v2/person"
  PEDIGREE_URL = "/familytree/v2/pedigree"
  PLACE_URL = "/authorities/v1/place"

  def self.dev_key
    config = YAML.load_file("#{Rails.root}/config/familysearch.yml")[Rails.env]
    config['web_key']
  end
  
  def self.api_url
    config = YAML.load_file("#{Rails.root}/config/familysearch.yml")[Rails.env]
    config['url']
  end
  
  def self.check_communicator(username, password)
    communicator = FsCommunicator.new :domain => 'https://'+api_url, :key => dev_key
    communicator.identity_v1.authenticate :username => username, :password => password
    communicator
  end

  def self.generate_person(tree, fs_id, name = nil, father_id = nil, mother_id = nil)
    p_fs_id = tree.familysearch_identifiers.find_by_fs_identifier(fs_id)
    if p_fs_id.nil?
      person = tree.people.build
    else
      person = p_fs_id.person
    end
    unless name.nil?
      person.name = name
    end
    unless father_id.nil?
      person.father_id = father_id
    end
    unless mother_id.nil?
      person.mother_id = mother_id
    end
    person.save
    if p_fs_id.nil?
      p_fs_id = person.familysearch_identifiers.build
      p_fs_id.fs_identifier = fs_id
      p_fs_id.save
    end
    person.id
  end

  def self.fetch_tree(communicator, tree, pid = nil)
    if pid.nil?
      tree_result = communicator.familytree_v2.pedigree :me
      root_id = tree_result.persons[0].id
    else
      tree_result = communicator.familytree_v2.pedigree pid
    end
    
    tree_result.persons.each do |person|
      father_id = nil
      mother_id = nil
      unless person.parents.nil?
        if person.parents.length > 0
          person.parents[0].parents.each do |parent|
            if parent.gender == "Male"
              father_id = generate_person(tree, parent.id)
            else
              mother_id = generate_person(tree, parent.id)
            end
          end
        end
      end
      generate_person(tree, person.id,  person.full_name, father_id, mother_id)
    end
    p_fs_id = tree.familysearch_identifiers.find_by_fs_identifier(root_id)
    unless p_fs_id.nil?
      tree.person_id = p_fs_id.person.id
      tree.save
    end
  end
end
