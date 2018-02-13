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

  def get_mentor_availability(mentor_id = @my_info_hash["current_enrollment"]["mentor_id"])
    response = self.class.get(api_url("/mentors/#{mentor_id}/student_availability"), headers: { authorization: @auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page_number = nil)
    if page_number
      response = self.class.get(api_url("/message_threads"), headers: { authorization: @auth_token }, body: { page: page_number})
    else
      response = self.class.get(api_url("/message_threads"), headers: { authorization: @auth_token })
    end
    JSON.parse(response.body)
  end


  def create_message(sender_email, recipient_id, subject = "No Subject", message_body )
    response = self.class.post(api_url("/messages"), {
      headers: { authorization: @auth_token },
      body: {
        sender: sender_email,
        recipient_id: recipient_id,
        subject: subject,
        :"stripped-text" => message_body
      }
    })
    p "Message Sent!" if response.success?
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post(api_url("/checkpoint_submissions"), {
      headers: { authorization: @auth_token },
      body: {
        assignment_branch: assignment_branch,
        assignment_commit_link: assignment_commit_link,
        checkpoint_id: checkpoint_id,
        comment: comment,
        enrollment_id: enrollment_id,
      }
    })
    p "Checkpoint submitted!" if response.success?
  end

  def api_url(destination)
    "https://www.bloc.io/api/v1" + destination
  end

end
