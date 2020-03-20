class UsersController < ApplicationController
  skip_before_action(:force_user_sign_in, { :only => [:new_registration_form, :create] })
  
  def new_registration_form
    render({ :template => "user_sessions/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.private = params.fetch("query_private", false)
    @user.username = params.fetch("query_username")

    save_status = @user.save

    if save_status == true
      session.store(:user_id,  @user.id)
   
      redirect_to("/", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => "User account failed to create successfully."})
    end
  end
    
  def edit_registration_form
    render({ :template => "users/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.private = params.fetch("query_private", false)
    @user.username = params.fetch("query_username")
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "users/edit_profile_with_errors.html.erb" })
    end
  end

  def destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end
  
  def homepage
    # User VISITED: Array and Country List
    @user_visits = CountryVisit.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_visit = @user_visits.pluck(:country)

    # User HIT LIST: Array and Country List
    @user_hits = CountryHitList.all.where({ :user_id => @current_user.id }).order({ :country => :asc })
    @user_countries_hit = @user_hits.pluck(:country) 
    
    # User Follow requests
    @user_follow_requests = FollowRequest.all.where({ :recipient_id => @current_user.id }).order({ :created_at => :desc })

    render({ :template => "users/homepage.html.erb" })
  end

  def userpage
    the_username = params.fetch("username").to_s
    @userpage = User.all.where({ :username => the_username }).at(0) 
    
    # Userpage VISITED: Array and Country List
    @userpage_visits = CountryVisit.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_visit = @userpage_visits.pluck(:country)

    # Userpage HIT LIST: Array and Country List
    @userpage_hits = CountryHitList.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_hit = @userpage_hits.pluck(:country) 

    if @current_user.id == @userpage.id
      redirect_to("/")
    else
      if @userpage.private == true
        if @userpage.followers.pluck(:sender_id).include?(@current_user.id) == true
          render({ :template => "users/userpage.html.erb" })
        else
          render({ :template => "users/userpage_private.html.erb" })
        end
      else
        render({ :template => "users/userpage.html.erb" })
      end
    end  

  end

  def userpage_followers
    the_username = params.fetch("username").to_s
    @userpage = User.all.where({ :username => the_username }).at(0) 
    
    # Userpage VISITED: Array and Country List
    @userpage_visits = CountryVisit.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_visit = @userpage_visits.pluck(:country)

    # Userpage HIT LIST: Array and Country List
    @userpage_hits = CountryHitList.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_hit = @userpage_hits.pluck(:country) 
    
    # Userpage FOLLOWERS
    @userpage_afollow_requests = FollowRequest.all.where({ :recipient_id => @userpage.id }).where({:status => "accepted"}).order({ :created_at => :desc })

      if @userpage.private == true
        if @userpage.followers.pluck(:sender_id).include?(@current_user.id) == true
          render({ :template => "follow_requests/userpage_followers.html.erb" })
        else
          render({ :template => "users/userpage_private.html.erb" })
        end
      else
        render({ :template => "follow_requests/userpage_followers.html.erb" })
      end
  end

  def userpage_following
    the_username = params.fetch("username").to_s
    @userpage = User.all.where({ :username => the_username }).at(0) 
    
    # Userpage VISITED: Array and Country List
    @userpage_visits = CountryVisit.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_visit = @userpage_visits.pluck(:country)

    # Userpage HIT LIST: Array and Country List
    @userpage_hits = CountryHitList.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_hit = @userpage_hits.pluck(:country) 

    # Userpage FOLLOWERS
    @userpage_afollowing = FollowRequest.all.where({ :sender_id => @userpage.id }).where({:status => "accepted"}).order({ :created_at => :desc })

      if @userpage.private == true
        if @userpage.followers.pluck(:sender_id).include?(@current_user.id) == true
          render({ :template => "follow_requests/userpage_following.html.erb" })
        else
          render({ :template => "users/userpage_private.html.erb" })
        end
      else
        render({ :template => "follow_requests/userpage_following.html.erb" })
      end
  end

  def userpage_visits
    the_username = params.fetch("username").to_s
    @userpage = User.all.where({ :username => the_username }).at(0) 
    
    # Userpage VISITED: Array and Country List
    @userpage_visits = CountryVisit.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_visit = @userpage_visits.pluck(:country)

    # Userpage HIT LIST: Array and Country List
    @userpage_hits = CountryHitList.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_hit = @userpage_hits.pluck(:country) 

    # Userpage VISITED: Array and Country List
    @userpage_visits = CountryVisit.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_visit = @userpage_visits.pluck(:country)

      if @userpage.private == true
        if @userpage.followers.pluck(:sender_id).include?(@current_user.id) == true
          render({ :template => "country_visits/userpage_index.html.erb" })
        else
          render({ :template => "users/userpage_private.html.erb" })
        end
      else
        render({ :template => "country_visits/userpage_index.html.erb" })
      end
  end

  def userpage_hit_list
    the_username = params.fetch("username").to_s
    @userpage = User.all.where({ :username => the_username }).at(0) 
    
    # Userpage VISITED: Array and Country List
    @userpage_visits = CountryVisit.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_visit = @userpage_visits.pluck(:country)

    # Userpage HIT LIST: Array and Country List
    @userpage_hits = CountryHitList.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_hit = @userpage_hits.pluck(:country) 

    # Userpage HIT LIST: Array and Country List
    @userpage_hits = CountryHitList.all.where({ :user_id => @userpage.id }).order({ :country => :asc })
    @userpage_countries_hit = @userpage_hits.pluck(:country) 

      if @userpage.private == true
        if @userpage.followers.pluck(:sender_id).include?(@current_user.id) == true
          render({ :template => "country_hit_lists/userpage_index.html.erb" })
        else
          render({ :template => "users/userpage_private.html.erb" })
        end
      else
        render({ :template => "country_hit_lists/userpage_index.html.erb" })
      end
  end

end
