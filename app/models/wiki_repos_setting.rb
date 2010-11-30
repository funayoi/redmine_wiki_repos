class WikiReposSetting < ActiveRecord::Base
  unloadable
  belongs_to :project

  protected
  def after_initialize
    self.index_page ||= "index"
    self.extension ||= ".txt"
  end

  def self.find_or_create(pj_id)
    setting = WikiReposSetting.find(:first, :conditions => ['project_id = ?', pj_id])
    unless setting
      setting = WikiReposSetting.new
      setting.project_id = pj_id
      setting.save!
    end
    return setting
  end

end
