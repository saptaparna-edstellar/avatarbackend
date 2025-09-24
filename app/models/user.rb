class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?

  # Active Storage association
  has_one_attached :avatar

  private

  def set_default_role
    self.role ||= "user"
  end
end
