class ApplicationController < ActionController::Base
  protect_from_forgery
  include FacebookHelper
  helper_method :fb_graph, :current_user

  protected

  def get_fb_session
    @oauth ||= Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    signed_request = @oauth.parse_signed_request(params[:signed_request]) rescue {}    
    if user_id = signed_request["user_id"]
      @fb_graph = Koala::Facebook::API.new(signed_request[:oauth_token])
      @fb_current_user = @fb_graph.get_object(user_id)
    else
      # page_url = "https://www.facebook.com/pages/Jigso/201051256634057?sk=app_225226567548351"
      # fb_redirect_to(fb_auth_url(:redirect_uri => page_url))
      # fb_redirect_to(fb_auth_url(:redirect_uri => fb_page_tab_url(@signed_request["page"]["id"])))
      fb_redirect_to(fb_auth_url)
      return false
    end
  end      

  def fb_graph
    @fb_graph || nil
  end

  def current_user
    @fb_current_user || nil
  end

end
