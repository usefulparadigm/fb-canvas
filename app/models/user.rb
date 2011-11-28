class User < ActiveRecord::Base
  serialize :data
  
  def to_s; data["name"] end
  
  def authorized?
    self.oauth_token.present? 
  end

  def deauthorize!
    self.update_attributes!(:oauth_token => nil)
  end
  
end
