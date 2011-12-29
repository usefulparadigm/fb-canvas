class WelcomeController < ApplicationController
  before_filter :require_auth

  def index
    @user = current_user
    @user_picture = fb_graph.get_picture('me')
    render :action => 'home'
  end

  def test
    facebook_cookies = @oauth.get_user_info_from_cookies(cookies)
    render :text => facebook_cookies.inspect, :layout => true
  end

end
