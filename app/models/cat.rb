# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birthdate   :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'date'

class Cat < ActiveRecord::Base

  validates :color, :sex, :birthdate, :name, :description, presence: true
  validates :color, inclusion: { in: %w(red orange yellow green blue indigo violet black white),
    message: "#{:color} is not a valid color"}
  validates :sex, inclusion: { in: %w(M F),
    message: "#{:sex} is not a valid sex"}

    has_many :cat_rental_requests, dependent: :destroy

  def age
    current_date = DateTime.now.to_date
    num_age = (current_date - self.birthdate).to_i
    @age = "#{num_age / 365} years, #{num_age % 365} days"
  end

end
