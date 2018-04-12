module RedmineWatchersGroups
  module GroupPatch

    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end

    def active?
      self.status == Group::STATUS_ACTIVE
    end

    def css_classes
      "group #{User::CSS_CLASS_BY_STATUS[status]}"
    end

    module ClassMethods

      def watcher_groups(watcher_ids)
        watcher_groups = []

        unless watcher_ids.empty?
          # simple combinations of watchers
          simple_watchers_combinations = watcher_ids.repeated_combination(watcher_ids.length).to_a.map(&:uniq).uniq

          simple_watchers_combinations.each do |simple_watchers_combination|
            # the first query find all groups that contains all the current watchers as members through
            # the combination of the IN clause and the COUNT equal to the length of the current watchers
            # array (https://stackoverflow.com/a/11811573).
            # this doesn't ensure that the groups found contains no more members then the current watchers.
            # the second query finds all groups that have exactly the same members cardinality than
            # the current watchers.
            # the intersection of these two result sets returns the groups that contain all the current
            # watchers as members and doesn't contain others members.
            watcher_groups +=
              Group.joins(:groups_users).
                where("groups_users.user_id IN (#{simple_watchers_combination.join(', ')})").
                group(:group_id).having("COUNT(group_id) = #{simple_watchers_combination.length}") &
                Group.joins(:groups_users).
                  group(:group_id).having("COUNT(group_id) = #{simple_watchers_combination.length}")
          end
        end

        watcher_groups.to_a
      end

    end

  end
end