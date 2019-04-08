module RedmineWatchersGroups
  module WatchersHelperPatch

    # add watchers groups to the list of watchers on the right sidebar of the issue's ui (show action)
    def watchers_list(object)
      user_list = super

      if object.is_a?(Issue)
        group_list = watchers_groups_list(object)

        user_list + group_list
      else
        user_list
      end
    end

    def watchers_groups_list(object)
      groups = object.groups

      remove_allowed = User.current.allowed_to?(
        "delete_#{object.class.name.underscore}_watchers".to_sym, object.project)
      content = ''.html_safe

      groups.each do |group|
        s = ''.html_safe
        s << link_to_group(group)
        if remove_allowed
          url = {:controller => 'watchers',
                 :action => 'destroy',
                 :object_type => object.class.to_s.underscore,
                 :object_id => object.id,
                 :user_id => group}
          s << ' '
          s << link_to(l(:button_delete), url,
                       :remote => true, :method => 'delete',
                       :class => "delete icon-only icon-del",
                       :title => l(:button_delete))
        end
        content << content_tag('li', s, :class => "group-#{group.id}")
      end

      content.present? ? content_tag('ul', content, :class => 'watchers') : content
    end

    def link_to_group(group)
      if group.is_a?(Group)
        name = h(group.name)
        if group.active? || (User.current.admin? && group.logged?)
          link_to name, edit_group_path(group, tab: 'users'), :class => group.css_classes
        else
          name
        end
      else
        h(group.to_s)
      end
    end

  end
end
