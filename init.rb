require 'redmine_watchers_groups/project_patch'
require 'redmine_watchers_groups/group_patch'
require 'redmine_watchers_groups/issue_patch'
require 'redmine_watchers_groups/watchers_controller_patch'
require 'redmine_watchers_groups/watchers_helper_patch'
require 'redmine_watchers_groups/issues_helper_patch'
require 'redmine_watchers_groups/watchers_groups_logger'

Rails.configuration.to_prepare do
  unless Project.included_modules.include? RedmineWatchersGroups::ProjectPatch
    Project.prepend(RedmineWatchersGroups::ProjectPatch)
  end

  unless Group.included_modules.include? RedmineWatchersGroups::GroupPatch
    Group.prepend(RedmineWatchersGroups::GroupPatch)
  end

  unless Issue.included_modules.include? RedmineWatchersGroups::IssuePatch
    Issue.prepend(RedmineWatchersGroups::IssuePatch)
  end

  # prepend the helper's patch before the controller's patch otherwise it must be call
  # WatchersController.send(:helper, :watchers)
  # after helper's patch has prepended
  unless WatchersHelper.included_modules.include? RedmineWatchersGroups::WatchersHelperPatch
    WatchersHelper.prepend(RedmineWatchersGroups::WatchersHelperPatch)
  end

  unless WatchersController.included_modules.include? RedmineWatchersGroups::WatchersControllerPatch
    WatchersController.prepend(RedmineWatchersGroups::WatchersControllerPatch)
  end

  unless IssuesHelper.included_modules.include? RedmineWatchersGroups::IssuesHelperPatch
    IssuesHelper.prepend(RedmineWatchersGroups::IssuesHelperPatch)
  end
end

Redmine::Plugin.register :redmine_watchers_groups do
  name 'Redmine Watchers Groups plugin'
  author 'Roberto Piccini'
  description <<-eos
    Give to the groups the ability to be added as watchers
  eos
  version '1.0.0'
  url 'https://github.com/piccio/redmine_watchers_groups'
  author_url 'https://github.com/piccio'

  settings default: { 'enable_log' => false }, partial: 'settings/watchers_groups'
end
