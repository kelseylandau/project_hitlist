class CountryHitListsController < ApplicationController
  def index
    @country_hit_lists = CountryHitList.all.order({ :created_at => :desc })

    render({ :template => "country_hit_lists/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @country_hit_list = CountryHitList.where({:id => the_id }).at(0)

    render({ :template => "country_hit_lists/show.html.erb" })
  end

  def create
    @country_hit_list = CountryHitList.new
    @country_hit_list.user_id = params.fetch("query_user_id")
    @country_hit_list.country = params.fetch("query_country")

    if @country_hit_list.valid?
      @country_hit_list.save
      redirect_to("/country_hit_lists", { :notice => "Country hit list created successfully." })
    else
      redirect_to("/country_hit_lists", { :notice => "Country hit list failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @country_hit_list = CountryHitList.where({ :id => the_id }).at(0)

    @country_hit_list.user_id = params.fetch("query_user_id")
    @country_hit_list.country = params.fetch("query_country")

    if @country_hit_list.valid?
      @country_hit_list.save
      redirect_to("/country_hit_lists/#{@country_hit_list.id}", { :notice => "Country hit list updated successfully."} )
    else
      redirect_to("/country_hit_lists/#{@country_hit_list.id}", { :alert => "Country hit list failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @country_hit_list = CountryHitList.where({ :id => the_id }).at(0)

    @country_hit_list.destroy

    redirect_to("/country_hit_lists", { :notice => "Country hit list deleted successfully."} )
  end
end
