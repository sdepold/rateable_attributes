class Rating < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :rateable_id, :rateable_type, :user_id, :rating
  validates_uniqueness_of :rateable_id, :scope => [:rateable_type, :user_id, :rateable_attribute]
  belongs_to :rateable, :polymorphic => true
end