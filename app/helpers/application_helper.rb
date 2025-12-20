module ApplicationHelper
  # 背景色が暗いなら白文字、明るいなら黒文字
  def text_color_for(bg_color)
    return "#000" if bg_color.blank?

    hex = bg_color.delete("#")

    r = hex[0..1].to_i(16)
    g = hex[2..3].to_i(16)
    b = hex[4..5].to_i(16)

    # W3C推奨の輝度計算
    brightness = (r * 299 + g * 587 + b * 114) / 1000

    brightness > 150 ? "#000" : "#FFF"
  end

  # ▼ X シェア文言
  def share_text(review)
    title = review.book.title
    color = review.image_tag.name

    "『#{title}』をレビューしました！\n私の印象カラーは “#{color}” です。📚🎨\n\n#BookImage"
  end

  def share_app_text
    "本の印象を“色”で表現する、新しい読書体験📚🎨\n\n#BookImage"
  end
end
