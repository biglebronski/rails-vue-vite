# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require_relative "simplecov_helper" if ENV["COVERAGE"]
require "rails_vue_vite"
require "action_view"
require "fileutils"
require "minitest/autorun"
require "rails/generators/test_case"

class Minitest::Test
  def with_tmpdir
    root = File.join(Dir.pwd, "tmp", "test-#{name}-#{Process.pid}-#{rand(1000)}")
    FileUtils.mkdir_p(root)
    yield(root)
  ensure
    FileUtils.rm_rf(root) if root
  end
end
