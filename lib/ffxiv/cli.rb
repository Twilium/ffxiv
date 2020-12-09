class CLI

    def run
        greeting
        provide_fc_name
    end

    def greeting
        # puts "Welcome to the FFXIV Free Company Search!".blink.cyan
        # puts " "

        puts "┌───────────────────────────────────────────┐"
        puts "│ " + "Welcome to the FFXIV Free Company Search!".blink.light_cyan + " │"
        puts "└──────────────∩─────────∩──────────────────┘"
        puts "..............." + "l(` ･ω ･´) l                  ".magenta
    end

    def choices
        prompt = TTY::Prompt.new
        if prompt.yes?("Would you like to add a server?".cyan)
            provide_fc_name_with_server
        else
            pull_free_company_no_server
        end
    end

    def provide_fc_name
        puts "Please provide name for Free Company".cyan
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
        puts "Please provide server name".cyan
        @server_name = gets.strip
        puts " "
        @free_companies = API.get_free_company_with_server_name(@free_company, @server_name)
        display_free_companies
    end

    def display_free_companies
        if @free_companies.length > 35
            puts "Too many results. Please try a more specific name or add a server name.".cyan
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
        if prompt.yes?("Would you like to see members of a Free Company?".cyan)
            puts "Please type number of desired Free Company:".cyan
            input = gets.strip.downcase
            puts " "
            if input.to_i.between?(1, @free_companies.length)
                company = @free_companies[input.to_i-1]
                @fc_members = API.get_free_company_member_by_id(company.id)
                display_free_company_members
            else
                puts "This number is not in range. Please try again.".cyan
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
            puts "<- all ->".red if @i != @fc_members.length
		    puts "<- less  ".yellow if @i == @fc_members.length
		    puts "  next ->".green if @i == 0
            puts "  next ->".green if @i >= 50 && @i+49 <@fc_members.length
            puts "<- previous  ".blue if @i != 0 && @i != @fc_members.length
		    puts ""
		    puts "type " + "ALL".red + " to see all members."
		    puts "type " + "LESS".yellow + " from the full list to return to the truncated list."
		    puts "type " + "NEXT".green + " to page through the list 50 members at a time."
		    puts "type " + "PREVIOUS".blue + " to return to the preview page."
            puts "type " + "SEARCH".light_magenta + " to do another search query."
            puts "type " + "EXIT".magenta + " to close the program."
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
            puts "Sorry, that's the end of the list!".red
            puts "Please try a different command: ".cyan
            page_iteration
        elsif input == "next"
            @i += 50
            display_free_company_members
        elsif input == "previous" && @i == 0
            puts "This is the beginning of the list!".red
            puts "Please try again: ".cyan
            page_iteration
        elsif input == "previous" && @i == @fc_members.length
            puts "This is the entire list!".red
            puts "Please try again: ".cyan
            page_iteration
        elsif input == "previous"
            @i -= 50
            display_free_company_members
        elsif input == "search"
            search_again_or_exit
        elsif input == "exit"
            goodbye
        else 
            puts "Sorry, that is not a valid command!".cyan
            puts "Please try again: ".cyan
            page_iteration
        end
    end

    def search_again_or_exit
        prompt = TTY::Prompt.new
        if prompt.yes?("Would you like to do another search?".cyan)
            provide_fc_name
        else
            goodbye
        end
    end 

    def goodbye
        puts "     .d888b.    .d888b.    .d888b.    d88888b.      ".light_cyan.bold
        puts "    .8P   Y8.  .8P   Y8.  .8P   Y8.   88    `8D     ".light_cyan.bold
        puts "    88         88     88  88     88   88      88    ".light_cyan.bold
        puts "    88   88P.  88     88  88     88   88      88    ".light_cyan.bold
        puts "    88     88  88     88  88     88   88      88    ".light_cyan.bold
        puts "    `8b    d8' `8b   d8'  `8b   d8'   88    .8D     ".light_cyan.bold
        puts "     `Y888P'    `Y888P'    `Y888P'    Y88888D'      ".light_cyan.bold
        puts ""
        puts "    d88888b.  .d       b.   d888888b                ".light_cyan.bold
        puts "    88    Y8.  `8P    Y8.   88'                     ".light_cyan.bold
        puts "    88    88    `BP  Y8.    88                      ".light_cyan.bold
        puts "    88888B       `BPY8.     8800000                 ".light_cyan.bold
        puts "    88    88       88       88                      ".light_cyan.bold
        puts "    88    d8'      88       88.                     ".light_cyan.bold
        puts "    Y88888P'       YP       Y888888P                ".light_cyan.bold
        exit
    end

end