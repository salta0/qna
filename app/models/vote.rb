class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :value, :votable_id, :votable_type, presence: true
end
