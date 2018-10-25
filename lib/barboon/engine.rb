require "rails/engine"

module Barboom
  class Engine < Rails::Engine
    isolate_namespace Barboom
  end
end