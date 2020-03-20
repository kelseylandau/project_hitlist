class CountryVisitsController < ApplicationController
  def index
    @country_visits = CountryVisit.all.order({ :country => :asc })
    @user_visits = CountryVisit.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_visit = @user_visits.pluck(:country)

    # User HIT LIST: Array and Country List
    @user_hits = CountryHitList.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_hit = @user_hits.pluck(:country) 

    render({ :template => "country_visits/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @country_visit = CountryVisit.where({:id => the_id }).at(0)

    render({ :template => "country_visits/show.html.erb" })
  end

  def create
    @country_visit = CountryVisit.new
    @country_visit.country = params.fetch("query_country")
    @country_visit.user_id = @current_user.id

    if @country_visit.valid?
      @country_visit.save
      redirect_to("/country_visits/", { :notice => "Country visit created successfully." })
    else
      redirect_to("/country_visits/", { :notice => "Country visit failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @country_visit = CountryVisit.where({ :id => the_id }).at(0)

    @country_visit.country = params.fetch("query_country")
    @country_visit.user_id = params.fetch("query_user_id")

    if @country_visit.valid?
      @country_visit.save
      redirect_to("/country_visits/#{@country_visit.id}", { :notice => "Country visit updated successfully."} )
    else
      redirect_to("/country_visits/#{@country_visit.id}", { :alert => "Country visit failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @country_visit = CountryVisit.where({ :id => the_id }).at(0)

    @country_visit.destroy

    redirect_to("/", { :notice => "Country visit deleted successfully."} )
  end


  def feed
    # ---------- FEED SHOWS THE RECENT VISITS ADDED BY LEADERS (WHO THE USER IS FOLLOWING)
    
    render({ :template => "country_visits/feed.html.erb" })
  end
end
