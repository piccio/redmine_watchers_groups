module RedmineWatchersGroups
  module ProjectPatch

    def groups
      @groups ||= Group.active.joins(:members).where("#{Member.table_name}.project_id = ?", id).distinct
    end

  end
end