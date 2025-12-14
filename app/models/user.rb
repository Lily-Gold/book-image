class User < ApplicationRecord
  include ImageProcessable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one_attached :avatar
  has_many :books, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 15 }, unless: :from_omniauth?
  validates :introduction, length: { maximum: 200 }
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: :from_omniauth?

  # ★ これを忘れない
  def from_omniauth?
    provider.present? && uid.present?
  end

  def self.from_omniauth(auth)
    email = auth.info.email
    return nil if email.blank?

    # ① Googleログイン済み
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # ② 通常登録 → Google紐づけ
    user = find_by(email: email)
    if user
      user.update!(
        provider: auth.provider,
        uid: auth.uid
      )
      return user
    end

    # ③ Google初回
    create!(
      provider: auth.provider,
      uid: auth.uid,
      email: email,
      name: auth.info.name || "Googleユーザー",
      password: Devise.friendly_token[0, 20]
    )
  end
end
