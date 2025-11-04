class AddChannelHashAndPayloadToSolidCableMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :solid_cable_messages, :channel_hash, :string
    add_column :solid_cable_messages, :payload, :text
  end
end
