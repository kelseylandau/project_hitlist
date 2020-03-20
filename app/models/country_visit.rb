# == Schema Information
#
# Table name: country_visits
#
#  id         :integer          not null, primary key
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class CountryVisit < ApplicationRecord
  belongs_to :user
end
