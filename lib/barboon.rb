require "barboon/engine"
require "barboon/list_item"
require "barboon/content"

module Barboon
  def self.parse(raw, format: :yml)
    items = []
    datas = []

    case format
    when :yml
      datas = YAML.load(raw)
    when :json
      datas = JSON.load(raw)
    else
      raise "format: #{format} not implement"
    end

    datas.each do |obj|
      items << ListItem.new(title: obj["title"], url: obj["url"], depth: obj["depth"], id: obj["id"])
    end
    Content.new(items)
  end
end