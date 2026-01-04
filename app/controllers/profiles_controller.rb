class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @reviews = current_user.reviews.order(created_at: :desc)
    @bookmarked_reviews = current_user.bookmarked_reviews
                                     .includes(:user, :book, :image_tag)
                                     .order("bookmarks.created_at DESC")

    @color_stats = fetch_color_stats
  end

  private

  def fetch_color_stats
    stats = current_user.reviews
                        .joins(:image_tag)
                        .group("image_tags.name", "image_tags.color")
                        .select(
                          "image_tags.name AS name",
                          "image_tags.color AS color",
                          "COUNT(*) AS count",
                          "MAX(reviews.created_at) AS latest_reviewed_at"
                        )

    return [] if stats.blank?

    stats.map do |s|
      {
        name: s.name,
        color: s.color,
        count: s.count.to_i,
        latest_reviewed_at: s.latest_reviewed_at
      }
    end
    .sort_by { |s| [ -s[:count], -s[:latest_reviewed_at].to_i ] }
  end
end
