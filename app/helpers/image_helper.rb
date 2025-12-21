module ImageHelper
  # ============================
  # メイン
  # ============================
  def display_image_url(record, size:, image_attribute:)
    cloudinary_url = cloudinary_image_url(record, size:, image_attribute:)
    return cloudinary_url if cloudinary_url.present?

    fallback_image_url(record, size, image_attribute)
  end

  # ============================
  # Cloudinary
  # ============================
  def cloudinary_image_url(record, size:, image_attribute:)
    attachment = record.public_send(image_attribute)
    return nil unless attachment&.attached?

    dim = image_dimensions(size)

    cl_image_path(
      attachment.key, # ← Cloudinary が理解できる key
      width:  dim[:width],
      height: dim[:height],
      crop:   :fill,
      quality: image_quality(size)
    )
  rescue => e
    Rails.logger.error "Cloudinary画像URL生成エラー: #{e.message}"
    nil
  end

  # ============================
  # ActiveStorage フォールバック
  # ============================
  def fallback_image_url(record, size, image_attribute)
    attachment = record.public_send(image_attribute)
    return nil unless attachment&.attached?

    dim = image_dimensions(size)

    rails_representation_url(
      attachment.variant(resize_to_fill: [dim[:width], dim[:height]])
    )
  rescue => e
    Rails.logger.error "ActiveStorageフォールバックエラー: #{e.message}"
    nil
  end

  # ============================
  # サイズ定義
  # ============================
  def image_dimensions(size)
    case size
    when :avatar_120 then { width: 120, height: 120 }
    when :avatar_48  then { width: 48,  height: 48  }
    when :avatar_40  then { width: 40,  height: 40  }
    when :avatar_26  then { width: 26,  height: 26  }
    when :avatar_header then { width: 48, height: 48 }
    when :cover_thumb  then { width: 120, height: 170 }
    when :cover_detail then { width: 240, height: 340 }
    else { width: 200, height: 200 }
    end
  end

  # ============================
  # 品質
  # ============================
  def avatar_size?(size)
    size.to_s.start_with?("avatar")
  end

  def image_quality(size)
    avatar_size?(size) ? :auto_low : :auto
  end
end
