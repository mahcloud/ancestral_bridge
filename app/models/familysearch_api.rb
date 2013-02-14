require 'nokogiri'
require 'rexml/document'
require 'pp'
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
  
  def self.query_session_id(username, password)
    begin
      xml = RestClient.get "https://"+username+":"+password+"@"+api_url+LOGIN_URL, :params => {:key => dev_key}
      if xml.code == 200
        f = Nokogiri::XML(xml)
        return f.xpath('//*[@id]').attr('id').to_s
      end
    rescue => e
    end
    false
  end

  def self.query_tree(session_id, tree, pid = nil)
    begin
      url = "https://"+api_url+PEDIGREE_URL
      unless pid.nil?
        url += "/"+pid
      end
      xml = RestClient.get url, :params => {:sessionId => session_id}
      if xml.code == 200
        root_id = ""
        doc = REXML::Document.new(xml)
        elements = REXML::XPath.match(doc.root)
        persons = []
        pids = []
        doc.root.each_recursive do |elem|
          root_id << elem.attribute('id').to_s if elem.name == "pedigree"
          persons << elem.to_s if elem.name == "person"
          pids << elem.attribute('id').to_s if elem.name == "person"
        end
        persons.each_with_index do |person, index|
          father_id = ""
          mother_id = ""
          name = ""
          doc = REXML::Document.new(person)
          elements = REXML::XPath.match(doc.root)
          doc.root.each_recursive do |elem|
            if elem.name == "parent" && elem.attribute('gender').to_s == "Male"
              father_id = elem.attribute('id').to_s
            end
            if elem.name == "parent" && elem.attribute('gender').to_s == "Female"
              mother_id = elem.attribute('id').to_s
            end
            if elem.name == "fullText"
              name = elem.text.to_s
            end
          end
          
          p_fs_id = tree.familysearch_identifiers.find_by_fs_identifier(pids[index])
          if p_fs_id.nil?
            fsp = tree.people.build
          else
            fsp = p_fs_id.person
          end
          fsp.name = name
          if father_id != ""
            father_fs_id = tree.familysearch_identifiers.find_by_fs_identifier(father_id)
            if father_fs_id.nil?
              father = tree.people.build
              father.save
              fsp.father_id = father.id
              father_fs_id = father.familysearch_identifiers.build
              father_fs_id.fs_identifier = father_id
              father_fs_id.save
            end
          end
          if mother_id != ""
            mother_fs_id = tree.familysearch_identifiers.find_by_fs_identifier(mother_id)
            if mother_fs_id.nil?
              mother = tree.people.build
              mother.save
              fsp.mother_id = mother.id
              mother_fs_id = mother.familysearch_identifiers.build
              mother_fs_id.fs_identifier = mother_id
              mother_fs_id.save
            end
          end
          fsp.save
          if p_fs_id.nil?
            p_fs_id = fsp.familysearch_identifiers.build
            p_fs_id.fs_identifier = pids[index]
            p_fs_id.save
          end
        end
        p_fs_id = tree.familysearch_identifiers.find_by_fs_identifier(root_id)
        unless p_fs_id.nil?
          tree.person_id = p_fs_id.person.id
          tree.save
        end
      end
    rescue => e
    end
  end
end
