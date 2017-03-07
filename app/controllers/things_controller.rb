require 'json'
require 'open-uri'

class ThingsController < ApplicationController
  before_action :set_thing, only: [:voting]

  def create_restaurant
    create_thing("restaurant")
  end

  def create_bar
    create_thing("bar")
  end

  def create_accommodation
    create_thing("accommodation")
  end


  def create_activity
    create_thing("activity")
  end

  def index
    @things = Thing.all
  end

  def new_scraper
    @house_listing = scrape_to_thing(airbnb_scraper(4))
  end

  def voting
    city = @thing.city
    type = @thing.thing_type
    @vote_scope = "#{type}-#{city.id}"
    vote_type = params[:vote_type]
    vote_weight = get_vote_weight(vote_type)
    vote(@thing, vote_weight)
    @votes = current_user.votes.where(vote_scope: @vote_scope)
    @votes_buttons_ids = get_vote_buttons_ids(@votes)
    respond_to do |format|
      format.html { redirect_to city_path(city)}
      format.js  # <-- will render `app/views/things/voting.js.erb`
    end
  end



  # def vote3
  #   thing = Thing.find(params[:id])
  #   thing.liked_by current_user, :vote_scope => thing.thing_type, :vote_weight => 3

  #   redirect_to things_path
  # end





  private

  def set_thing
    @thing = Thing.find(params[:id])
  end


  def thing_params
    params.require(:thing).permit(:name, :description, :price_range, :address, :link, :tag, :photo_link)
  end


  def create_thing(type)
    @thing = Thing.new(thing_params)
    @city = City.find(params[:id])
    @thing.thing_type = type
    @thing.city = @city
    if @thing.save
      @city.send(type.pluralize).first.destroy if @city.send(type.pluralize).size > 3
      respond_to do |format|
        format.html { redirect_to send("new_city_" + type.pluralize + "_path"), notice: " Successfully created" }
        format.js  # <-- will render `app/views/things/create_activity.js.erb`
      end
    else
      respond_to do |format|
        format.html { render ('cities/new_' + type.pluralize) }
        format.js  # <-- idem
      end
    end
  end

  def conflicting_vote(thing,stars)
    current_user.votes.select do |user_votes|
      user_votes[:vote_weight] == stars && user_votes[:vote_scope] == "#{thing.thing_type}-#{thing.city.id}"
    end
  end

  def vote(thing,stars)
    conflicting_vote(thing,stars).each {|vote| vote.destroy}
    thing.liked_by current_user, :vote_scope => "#{thing.thing_type}-#{thing.city.id}", :vote_weight => stars
  end

  def get_vote_weight(vote_type)
    if vote_type == "first"
      return 3
    elsif vote_type == "second"
      return 2
    elsif vote_type == "third"
      return 1
    else
      return 0
    end
  end

  def get_vote_buttons_ids(votes)
    result = []
    votes.each do |vote|
      weight_s = vote_weight_to_s(vote.vote_weight)
      result << "#{vote.votable_id}-#{weight_s}"
    end
    result
  end

  def vote_weight_to_s(weight)
    if weight == 3
      return "first"
    elsif weight == 2
      return "second"
    elsif weight == 1
      return "third"
    end
  end
end

