require 'httparty'
require 'json'

class Kele
  include HTTParty

  def initialize(email, password)
    response = self.class.post(api_url("/sessions"), body: { email: email, password: password })
    raise 'Invalid username or password.' if response.code == 401
    @auth_token = response["auth_token"]
  end
  
  def get_me
    response = self.class.get(api_url("/users/me"), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
  
  def api_url(destination)
    "https://www.bloc.io/api/v1" + destination
  end

end