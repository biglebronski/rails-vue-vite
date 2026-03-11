# frozen_string_literal: true

require "simplecov"
require "simplecov-lcov"

SimpleCov.command_name(ENV.fetch("SIMPLECOV_COMMAND_NAME", "root"))
SimpleCov.coverage_dir(ENV.fetch("COVERAGE_DIR", "coverage"))

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])

SimpleCov.start do
  enable_coverage :branch
  add_filter "/test/"
  add_filter "/vendor/"
end
