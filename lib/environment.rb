require_relative "./ffxiv/version"
require_relative "./ffxiv/cli"
require_relative "./ffxiv/api"
require_relative "./ffxiv/free_company_members"
require_relative "./ffxiv/free_company_search"

require "tty-progressbar"
require "tty-prompt"
require "tty-table"
require "pry"
require "httparty"
require "net/http"
require 'colorize'
module Ffxiv
  class Error < StandardError; end
  # Your code goes here...
end
