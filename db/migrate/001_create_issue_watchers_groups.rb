class CreateIssueWatchersGroups < ActiveRecord::Migration
  def change
    create_table :issue_watchers_groups do |t|
      t.references :issue
      t.references :group
    end
  end
end