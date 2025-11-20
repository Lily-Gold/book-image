class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @reviews = current_user.reviews.order(created_at: :desc)
  end
end
