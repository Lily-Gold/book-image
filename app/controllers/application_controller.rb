class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # Devise関係：Strong Parameter許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン必須
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, if: :public_page?

  protected

  # DeviseのStrong Parameter設定
  def configure_permitted_parameters
    # 新規登録
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # プロフィール編集
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :introduction])
  end

  # 直打ちでログインしたときは元のURLに戻し、普通のログイン時は reviews_path に戻す
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || reviews_path
  end

  private

  # 公開ページ（未ログインでも見れる場所）
  def public_page?
    controller_name == "homes" && action_name == "index"
  end
end
