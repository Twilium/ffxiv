class CLI

    def run
        greeting
        provide_fc_name
    end

    def greeting
        puts "Welcome to the FFXIV Free Company Search!"
        puts " "
    end

    def choices
        puts "Would you like to add a server?"
        input = gets.strip.downcase
        puts " "
        if input != "yes" && input != "y" && input != "no" && input != "n"
            puts "Sorry, I did not understand. Try again."
            puts " "
            choices
        elsif input == "no" || input == "n"
            pull_free_company_no_server
        else
            provide_fc_name_with_server
        end

    end

    def provide_fc_name
        puts "Please provide name for Free Company"
        @free_company = gets.strip
        puts " "
        choices
        # @free_companies = API.get_free_company(@free_company) 
        # display_free_companies
    end

    def pull_free_company_no_server
        @free_companies = API.get_free_company(@free_company) 
        display_free_companies
    end


    def provide_fc_name_with_server
        puts "Please provide server name"
        @server_name = gets.strip
        puts " "
        @free_companies = API.get_free_company_with_server_name(@free_company, @server_name)
        display_free_companies
    end

    def display_free_companies
        if @free_companies.length > 35
            puts "Too many results. Please try a more specific name or add a server name."
            puts " "
            provide_fc_name
        elsif @free_companies.length == 0
            puts " "
            puts "No results."
            puts " "
            search_again_or_exit
        else 
            @free_companies.each.with_index(1) do |fc, i| 
                fc_table = TTY::Table.new(header: ["#", "Free Company", "ID", "Server"])
                fc_table << ["#{i}", "#{fc.name}", "#{fc.id}", "#{fc.server}"]
                puts " "
                puts fc_table.render(:unicode)
                puts " "

            end
        end
        company_member_selection_or_new_search
    end

    def company_member_selection_or_new_search
        puts "Would you like to see members of a Free Company?"
        puts " "
        puts "Please type (Y)es or (N)o"
        input = gets.strip.downcase
        if input != "yes" && input != "y" && input != "no" && input != "n"
            puts "Sorry, I did not understand. Try again."
            puts " "
            company_member_selection_or_new_search
        elsif input == "yes" || input == "y"
            puts "Please type number of desired Free Company:"
            input = gets.strip.downcase
            puts " "
            if input.to_i.between?(1, @free_companies.length)
                company = @free_companies[input.to_i-1]
                @fc_members = API.get_free_company_member_by_id(company.id)
                display_free_company_members
            else
                puts "This number is not in range. Please try again."
                puts " "
                company_member_selection_or_new_search
            end
        else
            search_again_or_exit
        end
        search_again_or_exit
    end

    def display_free_company_members
        @fc_members.each.with_index(1) do |member, i|
            puts "#{i} - "
            puts "Name: #{member.name}"
            puts "ID: #{member.id}"
            puts "Rank: #{member.rank}"
            puts "Server: #{member.server}"
            puts " "
        end
    end

    def search_again_or_exit
        puts "Would you like to do another search?"
        puts "Type (Y)es to search again; type (N)o to exit application:"
        input = gets.strip.downcase
        puts " "
        if input != "yes" && input != "y" && input != "no" && input != "n"
            puts "Sorry, that is not a valid option. Please try again"
            puts " "
            search_again_or_exit
        elsif input == "yes" || input == "y"
            provide_fc_name
        else
            puts "Good bye!"
            exit
        end
    end 

end