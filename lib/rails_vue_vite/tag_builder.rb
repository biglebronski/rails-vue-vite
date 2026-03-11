# frozen_string_literal: true

module RailsVueVite
  class TagBuilder
    def initialize(view_context, config: RailsVueVite.config, manifest: Manifest.new(config: config))
      @view_context = view_context
      @config = config
      @manifest = manifest
    end

    def client_tag(**options)
      return "".html_safe unless config.dev_mode?

      src = dev_asset_url("@vite/client")
      view_context.javascript_include_tag(src, { type: "module" }.merge(options))
    end

    def javascript_tags(*entrypoints, **options)
      tags = entrypoints.flatten.filter_map do |entrypoint|
        next if entrypoint.blank?

        src = if config.dev_mode?
          dev_asset_url(entrypoint_source(entrypoint))
        else
          with_public_prefix(manifest.asset_path_for(entrypoint))
        end

        view_context.javascript_include_tag(src, { type: "module", crossorigin: "anonymous" }.merge(options))
      end

      view_context.safe_join(tags, "\n")
    end

    def stylesheet_tags(*entrypoints, **options)
      return "".html_safe if config.dev_mode?

      paths = entrypoints.flatten.flat_map { |entrypoint| manifest.stylesheet_paths_for(entrypoint) }.uniq
      tags = paths.map do |path|
        view_context.stylesheet_link_tag(with_public_prefix(path), { media: "screen" }.merge(options))
      end

      view_context.safe_join(tags, "\n")
    end

    private

    attr_reader :config, :manifest, :view_context

    def with_public_prefix(asset_path)
      File.join("/", config.public_output_dir, asset_path)
    end

    def entrypoint_source(entrypoint)
      value = entrypoint.to_s
      name = File.extname(value).empty? ? "#{value}.js" : value
      File.join(config.entrypoints_dir, name)
    end

    def dev_asset_url(path)
      join_url(config.dev_server_url, File.join(config.public_output_dir, path))
    end

    def join_url(base, path)
      "#{base.to_s.sub(%r{/*$}, "")}/#{path.to_s.sub(%r{\A/*}, "")}"
    end
  end
end
