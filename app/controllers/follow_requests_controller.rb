class FollowRequestsController < ApplicationController
  def index
    @follow_requests = FollowRequest.all.order({ :created_at => :desc })
    @user_follow_requests = FollowRequest.all.where({ :recipient_id => @current_user.id }).order({ :created_at => :desc })
    
    render({ :template => "follow_requests/user_followers.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @follow_request = FollowRequest.where({:id => the_id }).at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_id = params.fetch("query_recipient_id")
    @recipient = User.where({ :id => the_id }).at(0)
    
    @follow_request = FollowRequest.new
    @follow_request.recipient_id = params.fetch("query_recipient_id")
    @follow_request.sender_id = @current_user.id
    
    if @recipient.private == true
      @follow_request.status = "pending"
    else 
      @follow_request.status = "accepted"
    end

    if @follow_request.valid?
      @follow_request.save
      redirect_to("/users/#{@recipient.username}", { :notice => "Follow request sent." })
    else
      redirect_to("/users/#{@recipient.username}", { :notice => "Follow request failed to send." })
    end
  end

  def accept_follow
    the_id = params.fetch("path_id")
    @follow_request = FollowRequest.where({ :id => the_id }).at(0)
    
    @follow_request.status = "accepted"

    if @follow_request.valid?
      @follow_request.save
      redirect_to("/followers/", { :notice => "Follow request accepted successfully."} )
    else
      redirect_to("/followers/", { :alert => "Follow request failed to accepted successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @follow_request = FollowRequest.where({ :id => the_id }).at(0)
    @recipient = FollowRequest.where({ :id => the_id }).at(0).recipient_id

    @follow_request.destroy

    redirect_to("/follow_requests", { :notice => "Follow request deleted successfully."} )
  end
end
