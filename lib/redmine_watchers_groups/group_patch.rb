module RedmineWatchersGroups
  module GroupPatch

    def active?
      self.status == Group::STATUS_ACTIVE
    end

    def css_classes
      "group #{User::CSS_CLASS_BY_STATUS[status]}"
    end

  end
end