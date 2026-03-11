# frozen_string_literal: true

require_relative "lib/rails_vue_vite/version"

Gem::Specification.new do |spec|
  spec.name = "rails_vue_vite"
  spec.version = RailsVueVite::VERSION
  spec.authors = ["Dom Lebron"]
  spec.email = ["dev@untrackedstudio.com"]

  spec.summary = "Rails 7+ integration for Vue and Vite with predictable helpers and tests."
  spec.description = "rails_vue_vite connects Rails 7+ apps to a Vite-powered Vue frontend through view helpers, manifest resolution, and installation generators."
  spec.homepage = "https://github.com/untrackedstudio/rails-vue-vite"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/untrackedstudio/rails-vue-vite"
  spec.metadata["changelog_uri"] = "https://github.com/untrackedstudio/rails-vue-vite/releases"
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 7.0", "< 9.0"
end
