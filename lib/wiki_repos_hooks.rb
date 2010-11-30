require 'redmine'
class WikiReposHooks < Redmine::Hook::ViewListener

    render_on :view_layouts_base_html_head,
                :partial => 'wiki_repos/header'

end
