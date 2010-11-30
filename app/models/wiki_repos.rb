class WikiRepos < ActiveRecord::Base
  unloadable

  belongs_to :wiki_content
  belongs_to :change

  def synchronized?
    latest = change.class.find(:first, :order => "id DESC", :conditions => [ "path = ?", change.path])

    wiki_content.version == wiki_content_version && change == latest
  rescue
    nil
  end

  protected
  def self.find_or_create(wiki_content)
    repo = WikiRepos.find(:first, :conditions => ['wiki_content_id = ?', wiki_content.id])
    unless repo
      repo = WikiRepos.new
      repo.wiki_content_id = wiki_content.id
      repo.save!
    end
    return repo
  end
end
