class WikiReposSettingsController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project

  def show
  end

  def update
    setting = WikiReposSetting.find_or_create @project.id
    begin
      setting.transaction do
        setting.attributes = params[:setting]
        setting.save!
      end
      flash[:notice] = l(:notice_successful_update)
    rescue
      flash[:error] = "Updating failed."
    end

    redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'wiki_repos'
  end

  
  private
  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:id])
  end

  def find_user
    @user = User.current
  end
end
