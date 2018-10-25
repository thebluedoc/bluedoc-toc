require "taiku_toc/engine"
require "taiku_toc/list_item"
require "taiku_toc/content"

module TaikuToc
  extend ActiveSupport::Autoload

  module Format
    extend ActiveSupport::Autoload

    autoload :Markdown
  end

  def self.parse(raw, format: :yml)
    items = []
    datas = []

    case format
    when :yml
      datas = YAML.load(raw)
    when :json
      datas = JSON.load(raw)
    when :markdown
      datas = TaikuToc::Format::Markdown.load(raw)
    else
      raise "format: #{format} not implement"
    end

    datas.each do |obj|
      items << ListItem.new(title: obj["title"], url: obj["url"], depth: obj["depth"], id: obj["id"])
    end
    Content.new(items)
  end
end