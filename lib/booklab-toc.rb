require "booklab/toc/engine"
require "booklab/toc/list_item"
require "booklab/toc/content"
require "booklab/toc/format/markdown"

module BookLab
  module Toc
    extend ActiveSupport::Autoload


    def self.parse(raw, format: :yml)
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
        items << ListItem.new(title: obj["title"], url: obj["url"], depth: obj["depth"], id: obj["id"])
      end
      Content.new(items)
    end
  end
end