class WelcomeController < ApplicationController
  before_filter :require_auth

  def index
    @user = current_user
    render :action => 'home'
  end

  def test
    render :text => current_user.inspect, :layout => true
  end

end
