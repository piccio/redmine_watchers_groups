module RedmineWatchersGroups
  module IssuesHelperPatch

    # lists groups to "new issue" ui, "watchers section"
    def users_for_new_issue_watchers(issue)
      users = super

      groups = issue.project.groups.active.visible.sorted.to_a

      users + groups
    end

  end
end
