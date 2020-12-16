class FreeCompany

    @@all = []

    def initialize(attrs)
        attrs.each do |k, v|
            self.class.attr_accessor k.downcase
            self.send("#{k.downcase}=", v)
        end
        save
    end

    def save
        @@all << self
    end

    def self.all
        @@all
    end
end