class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_p3p_headers, :parse_signed_request

  protected

  include FacebookHelper
  helper_method :fb_graph, :current_user, :signed_in?

  def set_p3p_headers
    response.headers['P3P'] = 'CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'
  end

  def parse_signed_request
    @oauth ||= Koala::Facebook::OAuth.new(FB_APP_ID, FB_APP_SECRET)
    signed_request = @oauth.parse_signed_request(params[:signed_request]) rescue {}
    if user_id = signed_request["user_id"]
      oauth_token = signed_request["oauth_token"]
      if oauth_token
        graph = Koala::Facebook::API.new(oauth_token)
        user_data = graph.get_object('me')
        # user_picture = graph.get_picture('me')

        if @current_user = User.find_by_fb_user_id(user_id)
          @current_user.oauth_token = oauth_token
          @current_user.data = user_data
          @current_user.save!
        else
          @current_user = User.create!(:fb_user_id => user_id, :oauth_token => oauth_token, :data => user_data)  
        end
        session[:user_id] = @current_user.id
      else # maybe app was deauthorized
        @current_user = User.find_by_fb_user_id(user_id)
      end    
    end  
  end  

  def current_user
    @current_user ||= User.find(session[:user_id]) rescue nil
  end
  
  def require_auth
    unless current_user && current_user.oauth_token.present?
      fb_redirect_to(fb_auth_url)
      return false
    end
  end

  def fb_graph
    @fb_graph ||= Koala::Facebook::API.new(current_user.oauth_token)
  end

  def signed_in?
    !!current_user
  end
end
