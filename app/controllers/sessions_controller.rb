class SessionsController < ApplicationController

  # App Deauthorization
  # 
  # When a user of your app removes it in the App Dashboard or blocks the app in the News Feed, 
  # your app can be notified by specifying a Deauthorize Callback URL in the Developer App. 
  # During app removal we will send an HTTP POST request containing a single parameter, signed_request, 
  # which contains the user id (UID) of the user that just removed your app. 
  # You will not receive an user access token in this request 
  # and all existing user access tokens will be automatically expired.
  
  def destroy
    session[:user_id] = nil
    head :ok
  end
  
end
