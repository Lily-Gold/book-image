class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  # 通常登録のときは必須。Googleログイン時はnilでもOK
  validates :name, presence: true, length: { maximum: 15 }, unless: :from_omniauth?

  # 自己紹介は任意・最大200文字
  validates :introduction, length: { maximum: 200 }

  # provider と uid の組み合わせ管理（Googleログイン用）
  validates :provider, inclusion: { in: [ "google_oauth2" ], allow_nil: true }
  validates :uid, presence: true, if: :provider?
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  # Googleログインで作成されたユーザーか判定するためのメソッド
  def from_omniauth?
    provider.present? && uid.present?
  end
end
