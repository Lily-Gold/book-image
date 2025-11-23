module ImageHelper
  # ============================
  # メイン：単体画像URLを取得
  # ============================
  def display_image_url(record, size:, image_attribute:)
    cloudinary_url = cloudinary_image_url(record, size: size, image_attribute: image_attribute)
    return cloudinary_url if cloudinary_url.present?

    fallback_image_url(record, size, image_attribute)
  end

  # ============================
  # Cloudinary（単体）
  # ============================
  def cloudinary_image_url(record, size:, image_attribute:)
    return nil unless record.has_images?(image_attribute: image_attribute)

    key = record.image_key(image_attribute: image_attribute)
    return nil unless key.present?

    dim = image_dimensions(size)

    cl_image_path(
      key,
      width:  dim[:width],
      height: dim[:height],
      crop:   :fill,
      quality: :auto
    )
  rescue => e
    Rails.logger.error "Cloudinary画像URL生成エラー: #{e.message}"
    nil
  end

  # ============================
  # ActiveStorage フォールバック
  # ============================
  def fallback_image_url(record, size, image_attribute)
    return nil unless record.has_images?(image_attribute: image_attribute)

    blob = record.first_image(image_attribute: image_attribute)&.blob
    return nil unless blob.present?

    dim = image_dimensions(size)

    rails_representation_url(
      blob.variant(resize_to_fill: [ dim[:width], dim[:height] ])
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
    # ───── Avatar ─────
    when :avatar_120
      { width: 120, height: 120 }
    when :avatar_48
      { width: 48, height: 48 }
    when :avatar_40
      { width: 40, height: 40 }
    when :avatar_26
      { width: 26, height: 26 }

    # ───── Book Cover ─────
    when :cover_thumb
      { width: 120, height: 170 }
    when :cover_detail
      { width: 240, height: 340 }
    else
      { width: 200, height: 200 }
    end
  end
end
