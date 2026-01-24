class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    like = current_user.likes.find_or_create_by!(review: @review)

    # ▼ 自分の投稿には通知しない
    unless @review.user_id == current_user.id
      Notification.find_or_create_by!(
        user: @review.user,  # 通知を受け取る人（レビュー投稿者）
        actor: current_user, # いいねした人
        review: @review,
        action_type: "like"
      )
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    current_user.likes.find_by!(review: @review).destroy!

    # ▼ いいね解除と同時に通知も削除
    Notification.find_by(
      user: @review.user,
      actor: current_user,
      review: @review,
      action_type: "like"
    )&.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_review
    @review = Review.find_by!(public_id: params[:review_public_id])
  end
end
