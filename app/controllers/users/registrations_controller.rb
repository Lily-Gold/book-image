class Users::RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params)
    return super if params['password'].present?

    resource.update_without_password(params.except('current_password'))
  end
end
