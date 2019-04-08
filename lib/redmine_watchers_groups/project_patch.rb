module RedmineWatchersGroups
  module ProjectPatch

    # groups that are members of the project, used by
    # IssuesHelperPatch#users_for_new_issue_watchers
    # WatchersControllerPatch#users_for_new_watcher
    def groups
      @groups ||= Group.active.joins(:members).where("#{Member.table_name}.project_id = ?", id).distinct
    end

  end
end