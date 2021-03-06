class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :lists_users, dependent: :destroy
  has_many :collaborators, source: :user, through: :lists_users, foreign_key: :user_id

  validates :title, presence: true
  validates :public, inclusion: { in: [true, false] }
  validate :check_date_format, :due_date_greater_than_today?

  def self.public
    List.where('public = true')
  end

  def role(user)
    begin
      lists_users.where('user_id = ?', user).first.role
    rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotFound, NoMethodError => error
      return nil
    end
  end

  def percent_complete
    if items.count > 0
      ((items.where(completed: true).count.to_f / items.count) * 100).round
    else
      return 0
    end
  end

  protected

  def check_date_format
    return nil unless due_date_before_type_cast.present? && due_date_before_type_cast.class == String
    begin
      DateTime.parse(due_date_before_type_cast)
    rescue DateTime::ArgumentError
      errors.add(:due_date, "invalid")
    end
  end

  def due_date_greater_than_today?
    if due_date.present? && due_date < DateTime.now
      errors.add(:due_date, "cannot be less than current date and time")
    elsif due_date.nil?
      return nil
    else
      return true
    end
  end
end
