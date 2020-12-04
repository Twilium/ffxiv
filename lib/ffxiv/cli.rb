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
        counter = 1
        @free_companies.each do |free_company|
            # binding.pry
            puts "#{counter} - "
            puts "ID: " + free_company.id
            puts "Name: " + free_company.name
            puts "Server: " + free_company.server
            puts " "
            counter += 1
        end
        company_member_selection_or_new_search
    end

    def company_member_selection_or_new_search
        puts "Would you like to see members of a Free Company? Type "
        input = gets.strip.downcase
        while input != "exit"
            if input == "back"
                provide_fc_name
            elsif input.to_i.between?(1, @free_companies.length)
                company = @free_companies[input.to_i-1]
                @fc_members = API.get_free_company_member_by_id(company.id)
                display_free_company_members
            end
        end
    end

    def display_free_company_members
        counter = 1
        @fc_members.each do |member|
            puts "#{counter} - "
            puts "ID: #{member.id}"
            puts "Name: #{member.name}"
            puts "Rank: #{member.rank}"
            puts "Server: #{member.server}"
            puts " "
            counter += 1
        end
    end
end