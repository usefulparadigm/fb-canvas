class User < ActiveRecord::Base
  serialize :data
  
  def to_s; data["name"] end
end
