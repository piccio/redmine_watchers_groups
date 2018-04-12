module RedmineWatchersGroups
  class WatchersGroupsLogger < Logger

    def self.write(level, message)
      if Setting.plugin_redmine_watchers_groups['enable_log'] == 'true'
        logger ||= new("#{Rails.root}/log/watchers_groups.log")
        logger.send(level, message)
      end
    end

  end
end
