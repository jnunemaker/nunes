module Nunes
  class Engine < Rails::Engine
    isolate_namespace Nunes

    initializer "nunes.configure" do
      Nunes.configure
    end
  end
end
