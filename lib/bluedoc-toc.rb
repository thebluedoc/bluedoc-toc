require "bluedoc/toc/engine"
require "bluedoc/toc/list_item"
require "bluedoc/toc/content"
require "bluedoc/toc/format/markdown"

module BlueDoc
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
          item_hash = obj.to_hash
          item_hash.deep_symbolize_keys!
          items << ListItem.new(id: item_hash[:id], title: item_hash[:title], url: item_hash[:url], depth: item_hash[:depth])
        end
        Content.new(items)
      rescue => e
        raise FormatError.new(e.message) if strict
        logger.warn "BlueDoc::Toc.parse error:\n#{e.inspect}"
        Content.new([])
      end
    end
  end
end
