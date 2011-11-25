class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  include FacebookHelper
  helper_method :fb_graph, :current_user, :signed_in?

  # TODO: https://gist.github.com/b27550ce85afc6417e05

  def get_fb_session
    unless session[:user_id]
      @oauth ||= Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request = @oauth.parse_signed_request(params[:signed_request]) rescue {}    
      if user_id = signed_request["user_id"]
        @fb_graph = Koala::Facebook::API.new(signed_request["oauth_token"])
        @fb_current_user = @fb_graph.get_object("me")
        user = User.find_or_create_by_fb_user_id(user_id)
        user.update_attributes(:oauth_token => signed_request["oauth_token"], :data => @fb_current_user)
        @current_user = user
        session[:user_id] = user.id
      else
        fb_redirect_to(fb_auth_url)
        return false
      end
    end    
  end     
  
  def fb_graph
    @fb_graph ||= Koala::Facebook::API.new(current_user.oauth_token)
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  # def current_user=(user)
  #   @current_user = user
  #   session[:user_id] = user.id
  # end
end
