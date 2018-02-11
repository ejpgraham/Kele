require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
    @api_url = "https://www.bloc.io/api/v1"
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { email: email, password: password })
    p response.code
    raise 'Invalid username or password.' if response.code == 401
    @auth_token = response["auth_token"]
  end

end