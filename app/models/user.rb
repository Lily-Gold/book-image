class User < ApplicationRecord
  include ImageProcessable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one_attached :avatar
  attr_accessor :remove_avatar

  has_many :books, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 15 }, unless: :from_omniauth?
  validates :introduction, length: { maximum: 200 }
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: :from_omniauth?

  validate :validate_avatar_format_and_size

  before_validation :set_default_introduction, on: :create

  def from_omniauth?
    provider.present? && uid.present?
  end

  def set_default_introduction
    self.introduction ||= "よろしくお願いします。"
  end

  def self.from_omniauth(auth)
    email = auth.info.email
    return nil if email.blank?

    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    user = find_by(email: email)
    if user
      user.update!(
        provider: auth.provider,
        uid: auth.uid
      )
      return user
    end

    create!(
      provider: auth.provider,
      uid: auth.uid,
      email: email,
      name: auth.info.name || "Googleユーザー",
      password: Devise.friendly_token[0, 20]
    )
  end

  private

  # ▼ プロフィール画像のバリデーション
  def validate_avatar_format_and_size
    return unless avatar.attached?

    acceptable_types = [ "image/jpeg", "image/png" ]

    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, "は jpg / jpeg / png のみアップロードできます。")
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "のサイズは5MB以下にしてください。")
    end
  end
end
