class API
    attr_accessor :fc_name
    BASE_URL = "https://xivapi.com"

    def self.get_free_company(fc_name, *server_name)
        @fc_name = fc_name
        url = BASE_URL + "/freecompany/search?name=#{@fc_name}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_response = JSON.parse(response)
        formatted_response['Results'].map do |free_company|
            FreeCompanySearch.new(free_company)
        end
    end

    def self.get_free_company_member_by_id(id)
        url = BASE_URL + "/freecompany/#{id}?data=FCM"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_response = JSON.parse(response)
        members = formatted_response["FreeCompanyMembers"]
        members.map do |members|
            FreeCompanyMembers.new(members)
        end
    end
end