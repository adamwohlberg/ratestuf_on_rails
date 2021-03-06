class ItemFactory
  DELIMITERS = [' versus ', ' versus', ' versus', 'versus', ' vs.', 'vs.', ' vs', ' vs ']

  def self.create!(input, user)
    new(input, user).create_items
  end

  def initialize(input, user)
    @input = input
    @user = user
  end

  def create_items
    tokenize.each do |token|
      next if Item.exists?(name: token)
      break if Category.where("name LIKE concat('%', '#{token}', '%')").exists?
        item_id = Item.create!(name: token, url: "http://www.#{token}.com", user_id: @user.id).id
        Rating.create!(user_id: User.first.id, item_id: item_id, x_rating: 0.5, y_rating: 0.55, default_rating: true)
        CategoriesItem.create!(item_id: item_id, category_id: Category.first_or_create(name: "new item - category pending").id)
    end
    self
  end

  def tokenize
    result = []
    @stripped_input = @input.strip
    DELIMITERS.each do |versus|
      if @stripped_input.include?(versus)
        words = @stripped_input.split(versus)
        words.each do |word|
          result << (word.strip)
        end
        break
      end
    end
    result.present? ? result.flatten.uniq : [@stripped_input]
  end

  private
  def sanitized_name
    @sanitized_name ||= @input.strip
  end
end
