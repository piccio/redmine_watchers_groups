module RedmineWatchersGroups
  module IssuePatch

    def self.prepended(base)
      base.has_many :issue_watchers_groups
      base.has_many :groups, through: :issue_watchers_groups

      base.safe_attributes 'group_ids',
                           :if => lambda {|issue, user| issue.new_record? || issue.attributes_editable?(user) }
    end

    # translation of the parameters from groups ids to users ids
    # and create fake parameters for groups
    def safe_attributes=(attrs, user = User.current)
      if attrs.is_a?(Hash)
        if attrs['watcher_user_ids'].present?
          groups = Group.active.visible.where(id: attrs['watcher_user_ids'].compact.uniq)

          attrs['group_ids'] = groups.map(&:id).map(&:to_s)
          attrs['watcher_user_ids'] -= groups.map(&:id).map(&:to_s)

          groups.each do |group|
            group.users.each do |groups_user|
              attrs['watcher_user_ids'] << groups_user.id
            end
          end
        end
      end

      super
    end

  end
end