class User < ApplicationRecord
  has_secure_password
  has_many_attached :images

  validates_presence_of :email, :password_digest
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of  :email, case_sensitive: false
  validates :password, presence: true, confirmation: true, if: proc { password_digest_changed?  }
end
