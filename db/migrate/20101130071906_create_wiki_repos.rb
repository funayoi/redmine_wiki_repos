class CreateWikiRepos < ActiveRecord::Migration
  def self.up
    create_table :wiki_repos do |t|
      t.column :wiki_content_id, :integer
      t.column :change_id, :integer
      t.column :wiki_content_version, :integer
    end
  end

  def self.down
    drop_table :wiki_repos
  end
end
