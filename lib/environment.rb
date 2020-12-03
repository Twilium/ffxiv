require_relative "./ffxiv/version"
require_relative "./ffxiv/cli"
require_relative "./ffxiv/api"
require_relative "./ffxiv/free_company"
require_relative "./ffxiv/free_company_search"

require "pry"
require "httparty"
require "net/http"
module Ffxiv
  class Error < StandardError; end
  # Your code goes here...
end
