class CLI
    def initialize
        greeting
        provide_fc_name
    end

    def greeting
        puts "Welcome to the FFXIV Free Company Search"
    end

    def provide_fc_name
        puts "Please provide name for Free Company"
        free_company = gets
        puts free_company = free_company.chomp
        # puts free_company
        API.call(free_company) 
    end
end