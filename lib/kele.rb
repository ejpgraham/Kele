require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  include Roadmap
  attr_reader :my_info_hash, :auth_token

  def initialize(email, password)
    response = self.class.post(api_url("/sessions"), body: { email: email, password: password })
    raise 'Invalid username or password.' if response.code == 401
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url("/users/me"), headers: { authorization: @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("/mentors/#{mentor_id}/student_availability"), headers: { authorization: @auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page_number = nil)
    if page_number
      response = self.class.get(api_url("/message_threads?page=#{page_number}"), headers: { authorization: @auth_token })
    else
      response = self.class.get(api_url("/message_threads"), headers: { authorization: @auth_token })
    end
    JSON.parse(response.body)
  end


  def create_message(sender_email, recipient_id, subject = "No Subject", message_body, token)
    response = self.class.post(api_url("/messages"), {
      headers: { authorization: @auth_token },
      body: {
        sender: sender_email,
        recipient_id: recipient_id,
        subject: subject,
        "stripped-text" => message_body,
        token: token
      }
    })
    p "Message Sent!"  if response.success?
  end

  def api_url(destination)
    "https://www.bloc.io/api/v1" + destination
  end

end
