class RatingsController < ApplicationController
  def create
    @items = params[:items]
    if @items.present?
      @item_ids = []
      @items.each do |item|
        # TODO: add item already rated by this user then update instead of adding a new rating
        if already_rated_n_times?(item, 2)
          @last_rating = Rating.last_rating_of_user(current_user.id, item)
          @rating = @last_rating.update_attributes(user_id: current_user.id, item_id: item['id'], x_rating: item['x_rating'], y_rating: item['y_rating'])
          session[:message] = 'Congratulations! Your rating(s) were updated.'
        else
          @rating = Rating.create!(user_id: current_user.id, item_id: item['id'], x_rating: item['x_rating'], y_rating: item['y_rating'])
        end
        @item_ids << item['id']
      end
      session[:message] ||= 'Congratulations! Your rating(s) were saved.'
    end
    @ratings = Rating.generate_format(Rating.item_ratings(@item_ids))
    respond_to do |format|
      format.json { render :json => @ratings.to_json }
    end
  end

  private
  def already_rated_n_times?(item, number)
    Rating.fetch_rating(current_user.id, item).count > number
  end
end
