require "rails/engine"

module BlueDoc
  module Toc
    class Engine < Rails::Engine
      isolate_namespace BlueDoc::Toc
    end
  end
end