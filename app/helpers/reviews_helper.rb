module ReviewsHelper
  def truncate_for_two_lines(text, longer: false, compact: false)
    return "" if text.blank?

    if longer
      if compact
        # ネタバレなし（小さいカード）
        line1 = text.slice(0, 17) || ""
        line2 = text.slice(17, 16) || ""
        limit = 33
      else
        # ネタバレなし（通常カード）
        line1 = text.slice(0, 19) || ""
        line2 = text.slice(19, 18) || ""
        limit = 37
      end
    else
      if compact
        # ネタバレあり（小さいカード）
        line1 = text.slice(0, 12) || ""
        line2 = text.slice(12, 16) || ""
        limit = 28
      else
        # ネタバレあり（通常カード）
        line1 = text.slice(0, 14) || ""
        line2 = text.slice(14, 18) || ""
        limit = 32
      end
    end

    if text.length > limit
      "#{line1}#{line2}…"
    else
      "#{line1}#{line2}"
    end
  end
end
