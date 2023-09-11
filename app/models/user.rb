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

  validates :user_id, presence: true
  validates :follow_id, presence: true


  def get_profile_image(width, heigth)
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
      #頭文字
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
      #末尾
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
      #部分
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end


end
