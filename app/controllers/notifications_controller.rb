class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
                                 .order(read: :asc, created_at: :desc)
                                 .page(params[:page])
                                 .per(10)
  end

  def show
    notification = current_user.notifications.find(params[:id])
    notification.update!(read: true)

    redirect_to review_path(notification.review)
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read: true)

    redirect_to notifications_path, notice: "すべての通知を既読にしました"
  end
end
