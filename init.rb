require 'redmine'

#require_dependency 'wiki_repos_hooks'


# Patches to the Redmine core
require 'dispatcher'
Dispatcher.to_prepare :redmine_wiki_repos do
#  require_dependency 'wiki_controller'
  require_dependency 'change'
#  WikiController.send(:include, WikiControllerPatch)
  Change.send(:include, WikiReposChangePatch)
  
end

require 'wiki_repos_projects_helper_patch'


Redmine::Plugin.register :redmine_wiki_repos do
  name 'Wiki from repository plugin'
  author 'Tomoyuki Oishi'
  description 'リポジトリにある文書をWikiに同期します'
  version '0.0.1'
  url 'http://502s15.coop.osaka-u.ac.jp/dokuwiki/redmine/repowiki'
  author_url 'http://502s15.coop.osaka-u.ac.jp/dokuwiki/'

  menu :admin_menu, :wiki_repos, { :controller => 'wiki_repos', :action => 'index' }, :caption => 'Polls'
  #settings :default => {'cache_seconds' => '0'}, :partial => 'wiki_repos/settings'
  settings :default => {'foo'=>'bar'}, :partial => 'settings/update'

  permission :view_wiki_repos, :wiki_repos => :index
  project_module :wiki_repos do
    permission :view_wiki_repos, :wiki_repos => :index
    permission :wiki_repos_settings, {:wiki_repos_settings => [:show, :update]}
  end
end
