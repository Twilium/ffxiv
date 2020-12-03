class API
    attr_accessor :fc_name
    BASE_URL = "https://xivapi.com"

    def call(fc_name)
        @fc_name = fc_name
        url = BASE_URL + "/freecompany/search?name=#{@fc_name}"
        uri = URI(url)
        binding.pry
    end
end