class CreateIssueWatchersGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :issue_watchers_groups do |t|
      t.references :issue
      t.references :group
    end
  end
end