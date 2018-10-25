module TaikuToc
  class Content
    extend Forwardable

    attr_accessor :items

    def_delegators :@items, :[], :size, :<<, :map, :each, :as_json

    def _dump
      YAML.dump(items.as_json)
    end

    def to_yaml
      _dump
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
      ApplicationController.renderer.render(partial: "taiku-toc/content", locals: { format: format, items: items })
    end

    def initialize(items)
      @items = items
    end
  end
end