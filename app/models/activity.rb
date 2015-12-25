class Activity < ActiveRecord::Base
  scope :by_user, ->(user) { where(user_id: user.id) }

  belongs_to :user
end
