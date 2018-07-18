class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_oauth(auth)
    user = User.where(email: auth.uid, provider: auth.provider).first
      
    if user != nil then
      user.update!(uid: auth.extra.raw_info.display_name)
    end
                  
    unless user
      user = User.create(
        uid:      auth.extra.raw_info.display_name,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
      user.save!
    end
    current_user = user
  end
                  
  private
                  
    def self.dummy_email(auth)
      "#{auth.uid}"
    end
end
