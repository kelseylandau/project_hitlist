class CountryHitListsController < ApplicationController
  def index
    @country_hit_lists = CountryHitList.all.order({ :created_at => :desc })
    @user_hits = CountryHitList.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_hit = @user_hits.pluck(:country)

    # User VISITED: Array and Country List
    @user_visits = CountryVisit.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_visit = @user_visits.pluck(:country)

    render({ :template => "country_hit_lists/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @country_hit_list = CountryHitList.where({:id => the_id }).at(0)

    render({ :template => "country_hit_lists/show.html.erb" })
  end

  def create
    @country_hit_list = CountryHitList.new
    @country_hit_list.user_id = @current_user.id
    @country_hit_list.country = params.fetch("query_country")

    if @country_hit_list.valid?
      @country_hit_list.save
      redirect_to("/country_hit_lists", { :notice => "Country hit list created successfully." })
    else
      redirect_to("/country_hit_lists", { :notice => "Country hit list failed to create successfully." })
    end
  end

  def update_to_visit
    the_id = params.fetch("path_id")
    @country_hit_list = CountryHitList.where({ :id => the_id }).at(0)

    @country_hit_list.user_id = @current_user.id

    if @country_hit_list.valid?
      @country_hit_list.destroy

       @country_visit = CountryVisit.new
       @country_visit.country = @country_hit_list.country
       @country_visit.user_id = @current_user.id
       @country_visit.save

      redirect_to("/country_hit_lists/", { :notice => "Country moved to Visited successfully."} )
    else
      redirect_to("/country_hit_lists/", { :alert => "Country failed to moved to Visited successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @country_hit_list = CountryHitList.where({ :id => the_id }).at(0)

    @country_hit_list.destroy

    redirect_to("/country_hit_lists", { :notice => "Country hit list deleted successfully."} )
  end

  def discover
    # ---------- FEED SHOWS THE HITLIST COUNTRIES BY LEADERS (WHO THE USER IS FOLLOWING)
    @user_visits = CountryVisit.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_visit = @user_visits.pluck(:country)
    
    render({ :template => "country_hit_lists/discover.html.erb" })
  end

  def discover_2
    # ---------- FEED SHOWS THE COUNTRIES VISITED BY LEADERS (WHO THE USER IS FOLLOWING & HAS NOT VISITED)
    @user_visits = CountryVisit.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_visit = @user_visits.pluck(:country)

    render({ :template => "country_hit_lists/discover_visit.html.erb" })
  end

  def discover_3
    # ---------- FEED SHOWS THE COUNTRIES VISITED BY LEADERS (WHO THE USER IS FOLLOWING & ON USER HIT LIST)
    @user_visits = CountryVisit.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_visit = @user_visits.pluck(:country)

    # User HIT LIST: Array and Country List
    @user_hits = CountryHitList.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_hit = @user_hits.pluck(:country) 

    render({ :template => "country_hit_lists/discover_hit_list_friend.html.erb" })
  end
end
