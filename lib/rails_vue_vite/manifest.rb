# frozen_string_literal: true

module RailsVueVite
  class Manifest
    def initialize(config: RailsVueVite.config, root: default_root)
      @config = config
      @root = Pathname(root)
      @data = nil
    end

    def resolve(entrypoint)
      keys_for(entrypoint).each do |key|
        return data[key] if data.key?(key)
      end

      raise MissingEntrypointError, "Missing Vite entrypoint #{entrypoint.inspect} in #{manifest_path}"
    end

    def stylesheet_paths_for(entrypoint)
      Array(resolve(entrypoint)["css"])
    end

    def asset_path_for(entrypoint)
      resolve(entrypoint).fetch("file")
    end

    private

    attr_reader :config, :root

    def data
      @data ||= JSON.parse(File.read(manifest_path))
    rescue Errno::ENOENT => error
      raise Error, "Unable to read Vite manifest at #{manifest_path}: #{error.message}"
    rescue JSON::ParserError => error
      raise Error, "Invalid Vite manifest at #{manifest_path}: #{error.message}"
    end

    def manifest_path
      root.join(config.manifest_path)
    end

    def keys_for(entrypoint)
      value = entrypoint.to_s
      return [value] if value.include?("/")

      filename = ensure_extension(value)
      [
        File.join(config.entrypoints_dir, filename),
        File.join(config.entrypoint_root, filename)
      ]
    end

    def ensure_extension(value)
      File.extname(value).empty? ? "#{value}.js" : value
    end

    def default_root
      if defined?(Rails) && Rails.respond_to?(:root) && Rails.root
        Rails.root
      else
        Dir.pwd
      end
    end
  end
end
