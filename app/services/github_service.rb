class GithubService
	attr_accessor :access_token

	def initialize(params = nil)
		@access_token = !params.nil? ? params["access_token"] : nil
	end

	def header
		{"Authorization" => "token #{@access_token}",
		"Accept" => "application/json"}
	end

	def authenticate!(client_id, client_secret, code)
		response = Faraday.post "https://github.com/login/oauth/access_token", {
			client_id: client_id,
			client_secret: client_secret,
			code: code}, 
			{'Accept' => 'application/json'}
	    access_hash = JSON.parse(response.body)
	    @access_token = access_hash["access_token"]
    end

    def get_username
	    user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
	    user_json = JSON.parse(user_response.body)
	    user_json["login"]
	end

	def get_repos
		repo_resp = Faraday.get "https://api.github.com/user/repos",
			{},
			self.header

		repo_json = JSON.parse(repo_resp.body)
		repo_json.collect do |repo|
			GithubRepo.new(repo)
		end	
	end

	def create_repo(name)
		new_repo_resp = Faraday.post "https://api.github.com/user/repos",
		{"name" => name}.to_json,
		self.header
	end	
end