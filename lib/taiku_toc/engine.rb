require "rails/engine"

module TaikuToc
  class Engine < Rails::Engine
    isolate_namespace TaikuToc
  end
end