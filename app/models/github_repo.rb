class GithubRepo
	attr_accessor :name, :url

	def initialize(params)
		@name = params["name"]
		@url = params["html_url"]
	end
end