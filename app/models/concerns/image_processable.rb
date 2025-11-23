module ImageProcessable
  extend ActiveSupport::Concern

  # 画像が存在するか確認
  def has_images?(image_attribute:)
    send(image_attribute)&.attached?
  end

  # 最初の画像を取得
  def first_image(image_attribute:)
    return nil unless has_images?(image_attribute: image_attribute)
    send(image_attribute)
  end

  # Cloudinary用 key
  def image_key(image_attribute:)
    first_image(image_attribute: image_attribute)&.blob&.key
  end
end
