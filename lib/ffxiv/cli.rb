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
        @free_companies.each.with_index(1) do |free_company, i|
            # binding.pry
            puts "#{i} - "
            puts "ID: " + free_company.id
            puts "Name: " + free_company.name
            puts "Server: " + free_company.server
            puts " "
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
                break
            end
        end
        binding.pry
    end

    def display_free_company_members
        @fc_members.each.with_index(1) do |member, i|
            puts "#{i} - "
            puts "ID: #{member.id}"
            puts "Name: #{member.name}"
            puts "Rank: #{member.rank}"
            puts "Server: #{member.server}"
            puts " "
        end
    end
end