require "booklab/toc/engine"
require "booklab/toc/list_item"
require "booklab/toc/content"
require "booklab/toc/format/markdown"

module BookLab
  module Toc
    class FormatError < Exception; end

    extend ActiveSupport::Autoload

    class << self
      delegate :logger, to: Rails

      def parse(raw, format: :yml, strict: false)
        items = []
        datas = []

        case format
        when :yml
          datas = YAML.load(raw)
        when :json
          datas = JSON.load(raw)
        when :markdown
          datas = Format::Markdown.load(raw)
        else
          raise "format: #{format} not implement"
        end

        datas.each do |obj|
          items << ListItem.new(obj.to_hash.deep_symbolize_keys)
        end
        Content.new(items)
      rescue => e
        raise FormatError.new(e.message) if strict
        logger.warn "BookLab::Toc.parse error:\n#{e.inspect}"
        Content.new([])
      end
    end
  end
end
