# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING")
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED),
    message: "#{:status} not valid" }


  belongs_to :cat

  def overlapping_requests
    all_requests = cat.cat_rental_requests.where.not(id: self.id).where(start_date: self.start_date..self.end_date,
  end_date: self.start_date..self.end_date)
    # all_requests.select do |request|
    #   (request.start_date < self.end_date && request.star_date > self.end_date)
    #    || request.end_date < self.end_date && request.end_date > self.end_date
    #   request.end_date > self.start_date)
    # end
  end

  def overlapping_approved_requests
    overlapping_requests.select do |request|
      request.status == "APPROVED"
    end
  end

  def overlapping_pending_requests
    overlapping_requests.select do |request|
      request.status == "PENDING"
    end
  end

  def approve!
    # if self.status == "PENDING" && !overlapping_approved_requests
    #   self.status = "APPROVED"
    # end

    transaction do
      self.status = "APPROVED"
      self.save!
      raise "overlapping" unless overlapping_approved_requests.empty?
      overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
  end

  def deny!
    if self.status == "PENDING"
      self.status = "DENIED"
      self.save!
    else
      raise "Not pending"
    end
  end

end
