class CLI

    def run
        greeting
        provide_fc_name
    end

    def greeting
        # puts "Welcome to the FFXIV Free Company Search!".blink.cyan
        # puts " "

        puts "┌───────────────────────────────────────────┐"
        puts "│ " + "Welcome to the FFXIV Free Company Search!".blink.cyan + " │"
        puts "└──────────────∩─────────∩──────────────────┘"
        puts "...............l(` ･ω ･´) l                  "
    end

    def choices
        prompt = TTY::Prompt.new
        if prompt.yes?("Would you like to add a server?".light_cyan)
            provide_fc_name_with_server
        else
            pull_free_company_no_server
        end
    end

    def provide_fc_name
        puts "Please provide name for Free Company".cyan.bold
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
        puts ""
        puts "Please provide server name".cyan.bold
        @server_name = gets.strip
        puts " "
        @free_companies = API.get_free_company_with_server_name(@free_company, @server_name)
        display_free_companies
    end

    def display_free_companies
        if @free_companies.length > 35
            puts "Too many results. Please try a more specific name or add a server name.".bold.cyan
            puts " "
            provide_fc_name
        elsif @free_companies.length == 0
            puts " "
            puts "No results.".cyan.bold
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
        prompt = TTY::Prompt.new
        if prompt.yes?("Would you like to see members of a Free Company?")
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
        @i ||= 0
        @updated_fc_members = @i == @fc_members.length ? @fc_members : @fc_members[@i..@i+49]
        @updated_fc_members.each.with_index(1) do |member, i| 
            member_table = TTY::Table.new(header: ["#", "Member Name", "ID", "Rank", "Server"])
            member_table << ["#{i}", "#{member.name}", "#{member.id}", "#{member.rank}", "#{member.server}"]
            puts " "
            print member_table.render(:unicode)
        end
            puts ""
            puts "<- all ->" if @i != @fc_members.length
		    puts "<- less  " if @i == @fc_members.length
		    puts "  next ->" if @i == 0
		    puts "<- previous |" + "| next ->" if @i >= 50 && @i+49 <@fc_members.length
		    puts "<- previous  " if @i != 0
		    puts ""
		    puts "type ALL to see the full list."
		    puts "type LESS from the full list to return to the truncated list."
		    puts "type NEXT to page through the list 50 at a time."
		    puts "type PREVIOUS to return to the preview view."
            puts "type SEARCH to do another search query."
            puts "type EXIT to close the program."
            puts " "
            page_iteration
    end

    def page_iteration
        input = gets.strip.downcase
        if input == "all"
            @i = @fc_members.length
            display_free_company_members
        elsif input == "less"
            @i = 0
            display_free_company_members
        elsif input == "next" && @i+50 > @fc_members.length
            puts "Sorry, that's the end of the list!"
            puts "Please try a different command: "
            page_iteration
        elsif input == "next"
            @i += 50
            display_free_company_members
        elsif input == "previous" && @i == 0
            puts "This is the beginning of the list!"
            puts "Please try again: "
            page_iteration
        elsif input == "previous" && @i == @fc_members.length
            puts "This is the beginning of the list!"
            puts "Please try again: "
            page_iteration
        elsif input == "previous"
            @i -= 50
        elsif input == "search"
            search_again_or_exit
        elsif input == "exit"
            goodbye
        else 
            puts "Sorry, that is not a valid command!"
            puts "Please try again: "
            page_iteration
        end
    end

    def search_again_or_exit
        prompt = TTY::Prompt.new
        if prompt.yes?("Would you like to do another search?")
            provide_fc_name
        else
            goodbye
        end
    end 

    def goodbye
        binding.pry
        puts "Good bye!"
        exit
    end

end