class Post < ApplicationRecord
    def increment_views
        self.increment!(:views)
    end
    def increment_likes
        self.increment!(:likes)
    end
    def decrement_likes
        self.decrement!(:likes)
    end
    has_one_attached :image
    validates :title, presence: true, length: { minimum: 5, maximum: 50 } # ограничение введение символов для создания поста
    validates :title, presence: true, length: { minimum: 10, maximum: 1000 }
end
