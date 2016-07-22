class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentication_class = Authentication
  end

  has_many :authentications, dependent: :destroy
  accepts_nested_attribues_for :authentications
end
