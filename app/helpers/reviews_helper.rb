module ReviewsHelper
  def truncate_for_two_lines(text)
    return "" if text.blank?

    # 1行目14文字
    line1 = text.slice(0, 14) || ""

    # 2行目18文字
    line2 = text.slice(14, 18) || ""

    # 2行目が収まりきらない場合は "…" を付ける
    if text.length > 14 + 18
      "#{line1}#{line2}…"
    else
      "#{line1}#{line2}"
    end
  end
end
