# == Schema Information
#
# Table name: country_hit_lists
#
#  id         :integer          not null, primary key
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class CountryHitList < ApplicationRecord
  belongs_to :user
end
