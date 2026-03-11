# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rake"

Minitest::TestTask.create do |task|
  task.test_globs = ["test/*_test.rb"]
end

def dummy_spa_root
  File.expand_path("test/dummy_spa", __dir__)
end

def dummy_html_root
  File.expand_path("test/dummy_html", __dir__)
end

def dummy_spa_env
  {
    "BUNDLE_GEMFILE" => File.join(dummy_spa_root, "Gemfile"),
    "BUNDLE_USER_HOME" => ENV.fetch("BUNDLE_USER_HOME", "/tmp/bundle"),
    "COVERAGE" => ENV["COVERAGE"],
    "COVERAGE_DIR" => File.join(dummy_spa_root, "coverage"),
    "SIMPLECOV_COMMAND_NAME" => "dummy_spa"
  }
end

def dummy_html_env
  {
    "BUNDLE_GEMFILE" => File.join(dummy_html_root, "Gemfile"),
    "BUNDLE_USER_HOME" => ENV.fetch("BUNDLE_USER_HOME", "/tmp/bundle"),
    "COVERAGE" => ENV["COVERAGE"],
    "COVERAGE_DIR" => File.join(dummy_html_root, "coverage"),
    "SIMPLECOV_COMMAND_NAME" => "dummy_html"
  }
end

def bundle_command(*args)
  [Gem.ruby, "-S", "bundle", *args].join(" ")
end

namespace :dummy_spa do
  task :bundle do
    begin
      sh(dummy_spa_env, bundle_command("check"), chdir: dummy_spa_root)
    rescue StandardError
      sh(dummy_spa_env, bundle_command("install", "--local"), chdir: dummy_spa_root)
    end
  end

  task test: :bundle do
    sh(dummy_spa_env, bundle_command("exec", "rails", "test", "test/integration/spa_flow_test.rb"), chdir: dummy_spa_root)
  end
end

namespace :dummy_html do
  task :bundle do
    begin
      sh(dummy_html_env, bundle_command("check"), chdir: dummy_html_root)
    rescue StandardError
      sh(dummy_html_env, bundle_command("install", "--local"), chdir: dummy_html_root)
    end
  end

  task test: :bundle do
    sh(dummy_html_env, bundle_command("exec", "rails", "test", "test/integration/html_flow_test.rb"), chdir: dummy_html_root)
  end
end

task default: [:test, "dummy_spa:test", "dummy_html:test"]
