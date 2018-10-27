module BookLab
  module Toc
    module Format
      class Markdown
        class << self
          def load(raw)
            items = []
            lines = raw.split("\n")
            lines.each do |line|
              item = { "title" => nil, "url" => nil, "depth" => 0 }
              # replace * prefix to - prefix
              line = line.gsub(/^([\s]+)\*/, "\\1-")
              # calculate indent as depth
              item["depth"] = (line.match(/^([\s]+)/).to_s.length / 2.0).round

              # check line is include link
              m = line.match(/\[(?<title>.+?)\]\((?<url>.+?)\)/)

              if m
                item["title"] = m[:title]
                # pick up link
                item["url"] = m[:url].split(" ")[0]
              else
                # use chars after "-" as title
                item["title"] = line.gsub(/^[\s]?\-[\s]?/, "").strip
              end

              items << item
            end

            items
          end
        end
      end
    end
  end
end