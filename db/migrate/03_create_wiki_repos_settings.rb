class CreateWikiReposSettings < ActiveRecord::Migration
  def self.up
    create_table :wiki_repos_settings do |t|
      t.column :project_id, :integer
      t.column :base_path, :string
      t.column :index_page, :string
      t.column :extension, :string
    end
  end

  def self.down
    drop_table :wiki_repos_settings
  end
end
