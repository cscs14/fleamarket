class User < ApplicationRecord
  include ActiveRecord::Reflection
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable,omniauth_providers: [:facebook, :google_oauth2]
  has_many :sns_credentials, dependent: :destroy
  has_many :freemarkets
  has_one :deliver_address ,dependent: :destroy
  accepts_nested_attributes_for :deliver_address, allow_destroy: true
  
  has_many :orders
  has_many :cards


  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = User.where(id: snscredential.user_id).first
    else
      user = User.where(email: auth.info.email).first
      if user.present?
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      else
        user = User.create(
          nickname: auth.info.name,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20],
          )
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      end
    end
    return user
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A[a-z0-9]+\z/i
  VALID_PHONE_REGEX = /\A\d{10}$|^\d{11}\z/

  with_options on: :profile do | profile |
    profile.validates :nickname,
      presence: true,
      length:{ maximum: 20}
    profile.validates :email,
      presence: true,
      format: { with: VALID_EMAIL_REGEX , message: 'のフォーマットが不適切です'}
    profile.validates :password,
      presence:true,
      confirmation: true,
      length:{ minimum: 7, maximum: 128},
      format: { with: VALID_PASSWORD_REGEX , message: 'は英字と数字両方を含むパスワードを設定してください'}
    profile.validates :last_name,
      presence: true,
      length:{ maximum: 35}
    profile.validates :first_name,
      presence: true,
      length:{ maximum: 35}
    profile.validates :last_name_kana,
      presence: true,
      length:{ maximum: 35},
      format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい' }
    profile.validates :first_name_kana,
      presence: true,
      length: { maximum: 35},
      format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい' }
    profile.validate :check_birthday  #生年月日用の独自バリデーション
  end
  
  def check_birthday
   
    if birthday.present?
      if birthday > Date.today
        
        errors.add(:birthday, "を正しく入力してください")
      end
    else
    
      errors.add(:birthday, "を入力してください")
    end
  end

end