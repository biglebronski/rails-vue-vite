ENV["RAILS_ENV"] ||= "test"
require_relative "../../../test/simplecov_helper" if ENV["COVERAGE"]
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
end
