module Roadmap

  def get_roadmap(roadmap_id = @my_info_hash["current_enrollment"]["roadmap_id"])
    response = self.class.get(api_url("/roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(api_url("/checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

end
