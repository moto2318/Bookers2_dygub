class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

    # 自分がフォローをする側
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

    # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower


  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :email, presence: true

  def get_profile_image(width, heigth)
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #　フォローしたときの処理
def follow(user_id)
  followers.create(followed_id: user_id)
end

#　フォローを外すときの処理
def unfollow(user_id)
  followers.find_by(followed_id: user_id).destroy
end

#フォローしていればtrueを返す
def following?(user)
  following_users.include?(user)
end
end
