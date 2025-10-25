class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Deviseのときだけ、Strong Parameter設定を呼ぶ
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # プロフィール編集
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :introduction, :profile_image])
  end

  def after_sign_in_path_for(resource)
    reviews_path
  end
end
