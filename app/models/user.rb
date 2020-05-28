class User < ApplicationRecord
  has_secure_password
  has_many_attached :images

  validates_presence_of :email, :password_digest
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of  :email, case_sensitive: false
  validates :password, presence: true, confirmation: true, if: proc { password_digest_changed?  }
  validate :password_type

  protected
  def password_type
    return if self.password.blank?

    unless match_data = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8}$/i.match(self.password)
      errors.add(:password, "only 8 digits allowed, should contain at least one number, one special character, one capital letter, one small letter")
    end
  end
end
