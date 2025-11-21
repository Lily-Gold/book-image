class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!
  skip_before_action :authenticate_user!, if: :public_page?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :introduction])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || reviews_path
  end

  private

  # ▼ 公開ページの定義（ログイン不要で閲覧可能）
  def public_page?
    # トップページ（homes#index）
    return true if controller_name == "homes" && action_name == "index"

    # レビュー一覧 & レビュー詳細は公開
    return true if controller_name == "reviews" && action_name.in?(%w[index show])

    false
  end

  # ★★★ 検索ワードを正規化（全文字列を半角化 & スペース統一）
  def normalize_query(str)
    return "" if str.blank?

    # 全角英数 → 半角英数
    s = str.tr("０-９Ａ-Ｚａ-ｚー－", "0-9A-Za-z--")

    # 全角スペース → 半角スペース
    s = s.tr("　", " ")

    # 余計なスペースを整理
    s.squeeze(" ").strip
  end
end
