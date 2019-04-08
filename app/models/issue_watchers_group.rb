class IssueWatchersGroup < ActiveRecord::Base
  belongs_to :issue
  belongs_to :group

  validates_presence_of :issue
  validates_presence_of :group
  validates_uniqueness_of :group_id, :scope => [:issue_id]
  validate :validate_group

  protected

  def validate_group
    errors.add :group_id, :invalid unless group.nil? || group.active?
  end
end
