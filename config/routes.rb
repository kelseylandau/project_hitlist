Rails.application.routes.draw do

  #------------------------------

  # Routes for the User account:
  get("/", { :controller => "users", :action => "homepage"})

  get("/users/:username", { :controller => "users", :action => "userpage"})
  get("/users/:username/followers", { :controller => "users", :action => "userpage_followers"})
  get("/users/:username/following", { :controller => "users", :action => "userpage_following"})
  get("/users/:username/visits", { :controller => "users", :action => "userpage_visits"})
  get("/users/:username/hit_list", {:controller => "users", :action => "userpage_hit_list"})

  # SIGN UP FORM
  get("/user_sign_up", { :controller => "users", :action => "new_registration_form" })        
  # CREATE RECORD
  post("/insert_user", { :controller => "users", :action => "create"  })
      
  # EDIT PROFILE FORM        
  get("/edit_user_profile", { :controller => "users", :action => "edit_registration_form" })       
  # UPDATE RECORD
  post("/modify_user", { :controller => "users", :action => "update" })
  
  # DELETE RECORD
  get("/cancel_user_account", { :controller => "users", :action => "destroy" })

  # ------------------------------

  # SIGN IN FORM
  get("/user_sign_in", { :controller => "user_sessions", :action => "new_session_form" })
  # AUTHENTICATE AND STORE COOKIE
  post("/user_verify_credentials", { :controller => "user_sessions", :action => "create_cookie" })
  
  # SIGN OUT        
  get("/user_sign_out", { :controller => "user_sessions", :action => "destroy_cookies" })

  #------------------------------

  # Routes for the Country visit resource:

  # CREATE
  post("/insert_country_visit", { :controller => "country_visits", :action => "create" })
          
  # READ
  get("/country_visits", { :controller => "country_visits", :action => "index" })
  
  get("/country_visits/:path_id", { :controller => "country_visits", :action => "show" })
  
  # UPDATE
  
  post("/modify_country_visit/:path_id", { :controller => "country_visits", :action => "update" })
  
  # DELETE
  get("/delete_country_visit/:path_id", { :controller => "country_visits", :action => "destroy" })

  # Routes for the Country hit list resource:

  # CREATE
  post("/insert_country_hit_list", { :controller => "country_hit_lists", :action => "create" })
          
  # READ
  get("/country_hit_lists", { :controller => "country_hit_lists", :action => "index" })
  
  get("/country_hit_lists/:path_id", { :controller => "country_hit_lists", :action => "show" })
  
  # UPDATE
  
  get("/move_country_hit_list/:path_id", { :controller => "country_hit_lists", :action => "update_to_visit" })
  
  # DELETE
  get("/delete_country_hit_list/:path_id", { :controller => "country_hit_lists", :action => "destroy" })

  #------------------------------

  # Routes for the Follow request resource:

  # CREATE
  post("/insert_follow_request", { :controller => "follow_requests", :action => "create" })
          
  # READ
  get("/followers", { :controller => "follow_requests", :action => "followers_index" })
  get("/following", { :controller => "follow_requests", :action => "following_index" })
  
  get("/follow_requests/:path_id", { :controller => "follow_requests", :action => "show" })
  
  # UPDATE
  
  get("/accept_follow_request/:path_id", { :controller => "follow_requests", :action => "accept_follow" })
  
  # DELETE
  get("/delete_follow_request/:path_id", { :controller => "follow_requests", :action => "destroy" })
             
  #------------------------------

  # ======= Add Your Routes Above These =============
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
