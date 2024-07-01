json.extract! photo, :id, :image, :commments_count, :likes_count, :caption, :owner_id, :created_at, :updated_at
json.url photo_url(photo, format: :json)
