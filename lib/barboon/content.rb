module Barboon
  class Content
    extend Forwardable

    attr_accessor :items

    def_delegators :@items, :[], :size, :<<, :map, :each

    def _dump
      YAML.dump(records)
    end

    def to_html
      _render(format: :html)
    end

    def to_markdown
      _render(format: :markdown)
    end

    def to_json
      items.to_json
    end

    def _render(format: :html)
      ApplicationController.renderer.render(partial: "barboon/content", locals: { format: format, items: items })
    end

    def initialize(items)
      @items = items
    end
  end
end