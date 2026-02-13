class Users::RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params)
    # avatar を削除
    if params[:remove_avatar] == "1"
      resource.avatar.purge
    end

    # パスワード未変更時は current_password 不要
    return super if params["password"].present?

    resource.update_without_password(params.except("current_password"))
  end
end
