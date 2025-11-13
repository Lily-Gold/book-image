# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# ---- ImageTag ----
image_tags = [
  { name: "情熱", color: "#CA1028" },
  { name: "活力", color: "#CC4613" },
  { name: "楽しい", color: "#D9760F" },
  { name: "明るい", color: "#CCB914" },
  { name: "新鮮", color: "#8CA113" },
  { name: "安らぎ", color: "#27853F" },
  { name: "自由", color: "#297364" },
  { name: "知性", color: "#205B85" },
  { name: "悲しみ", color: "#233B8B" },
  { name: "神秘", color: "#3D1C83" },
  { name: "優美", color: "#5E2883" },
  { name: "刺激", color: "#990F4F" },
  { name: "愛情", color: "#E67A8E" },
  { name: "爽やか", color: "#7DB6D0" },
  { name: "安心", color: "#7A523D" },
  { name: "恐怖", color: "#000000" },
  { name: "曖昧", color: "#808080" },
  { name: "無", color: "#FFFFFF" }
]

image_tags.each do |tag|
  record = ImageTag.find_or_initialize_by(name: tag[:name])
  record.update!(color: tag[:color])
end
