class API
    attr_accessor :fc_name
    BASE_URL = "https://xivapi.com"

    def initialize(fc_name)
        @fc_name = fc_name
    end
    
    def call(fc_name)
        url = BASE_URL + "/freecompany/search?name=#{@fc_name}"
        uri = URI(url)
        binding.pry
    end
end