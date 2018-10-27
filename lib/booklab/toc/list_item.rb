module BookLab
  module Toc
    class ListItem
      attr_accessor :title, :url, :slug, :depth, :id

      def initialize(title:, url: nil, depth: 0, id: nil)
        @title = title
        @url = url
        @depth = depth
        @id = id
      end
    end
  end
end