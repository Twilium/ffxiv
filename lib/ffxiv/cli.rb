class CLI
    def run
        greeting
        provide_fc_name
    end

    def greeting
        puts "Welcome to the FFXIV Free Company Search"
    end

    def provide_fc_name
        puts "Please provide name for Free Company"
        free_company = gets.strip
        # puts free_company
        @free_companies = API.get_free_company(free_company) 
        display_free_companies
    end

    def display_free_companies
        @free_companies.each do |free_company|
            # binding.pry
            puts "ID: " + free_company.id
            puts "Name: " + free_company.name
            puts "Server: " + free_company.server
        end
    end

    def company_member_selection_or_new_search
        puts "Select number of company"
        input = gets.strip.downcase
        while input != "exit"
            if input == "back"
                provide_fc_name
            elsif input.to_i.between?(1..@free_companies.length)
                company = @free_companies[input.to_i-1]
                API.get_free_company_member_by_id(company.id)
            end
        end
    end

end