module BookLab
  module Toc
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

      def to_html(prefix: nil)
        _render(format: :html, prefix: prefix)
      end

      def to_markdown(prefix: nil)
        _render(format: :markdown, prefix: prefix)
      end

      def to_json
        items.to_json
      end

      def _render(format: :html, prefix: nil)
        ApplicationController.renderer.render(partial: "booklab/toc/content", locals: { 
          format: format, 
          prefix: prefix,
          items: items,
        })
      end

      def initialize(items)
        @items = items
      end
    end
  end
end