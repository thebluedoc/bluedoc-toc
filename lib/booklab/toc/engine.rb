require "rails/engine"

module BookLab
  module Toc
    class Engine < Rails::Engine
      isolate_namespace BookLab::Toc
    end
  end
end