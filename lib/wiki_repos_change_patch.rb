require_dependency 'change'
require_dependency 'wiki'
require_dependency 'wiki_repos'

module WikiReposChangePatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      after_save :update_wiki_from_change
      #after_destroy :remove_kanban_issues

      # Add visible to Redmine 0.8.x
#      unless respond_to?(:visible)
#        named_scope :visible, lambda {|*args| { :include => :project,
#            :conditions => Project.allowed_to_condition(args.first || User.current, :view_issues) } }
#      end
    end

  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    
    def update_wiki_from_change
      project = changeset.repository.project
      wiki = project.wiki
      return true unless wiki
      setting = WikiReposSetting.find_or_create(project.id)

      entry = changeset.repository.entry(path, changeset.revision)
      if entry and not entry.is_dir?
        path_ary = path.split('/')
        path_ary.last =~ /^(.+)(\.txt)$/
        title = $1
        extension = $2
        return true unless extension == setting.extension
        if title == setting.index_page then
          parent_title = (path_ary.size >= 3) ? path_ary[-3] : wiki.start_page
          title = path_ary[-2]
        else
          parent_title = (path_ary.size >= 2) ? path_ary[-2] : wiki.start_page
        end
        page = wiki.find_or_new_page(title)
        parent_page = wiki.find_page(parent_title)
        
        # TODO: file_content を UTF-8 に変換
        file_content = changeset.repository.cat(path, changeset.revision)
        page.content = WikiContent.new(:page => page) if page.new_record? or not page.content
        page.content.text = file_content
        #page.content.author = changeset.repository.find_committer_user(changeset.committer) 
        page.content.author = changeset.user
        page.parent = parent_page

        # Wikiのコメントに、元になったリビジョンを記載
        csettext = "r#{changeset.revision}"
        if changeset.scmid && (! (csettext =~ /^r[0-9]+$/))
          csettext = "commit:\"#{changeset.scmid}\""
        end
        page.content.comments = "synced with #{csettext}"
        
        #page.new_record? ? page.save : page.content.save
        page.save
        page.content.save

        # リポジトリ情報を記録
        repos = WikiRepos.find_or_create(page.content)
        repos.change = self
        repos.wiki_content_version = page.content.version
        repos.save!

        puts repos.synchronized?
        
        puts title
      end

      return true
    end
  end
end