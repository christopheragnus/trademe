class Task < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user
  include PgSearch
     pg_search_scope :search,
                     against: [
                       :title,
                       :location
                     ],
                     using: {
                       tsearch: {
                         prefix: true,
                         normalization: 2
                       }
                     }
  def self.perform_search(keyword)
    if keyword.present?
    then Task.search(keyword)
    else Task.all
    end
  end

  # old uploader for reference
  #mount_uploader :image, ImageUploader
  has_one_attached :image
  validates :image, presence: true
  has_many :bids, dependent: :destroy
  has_one :location, dependent: :destroy

end
