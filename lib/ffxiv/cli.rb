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
        free_companies = API.get_free_company(free_company) 
        display_free_companies(free_companies)
    end

    def display_free_companies(free_companies)
        free_companies.each do |free_company|
            # binding.pry
            puts "ID: " + free_company.id
            puts "Name: " + free_company.name
            puts "Server: " + free_company.server
        end

    end

end