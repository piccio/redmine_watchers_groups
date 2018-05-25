module RedmineWatchersGroups
  module IssuePatch

    def safe_attributes=(attrs, user = User.current)
      if attrs.is_a?(Hash)
        if attrs['watcher_user_ids'].present?
          groups = Group.active.visible.where(id: attrs['watcher_user_ids'].compact.uniq)

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