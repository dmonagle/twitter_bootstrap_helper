require 'twitter_bootstrap_helper/helpers/twitter_bootstrap_helper'

module TwitterBootstrapHelper
  class Railtie < Rails::Railtie
    initializer "TwitterBootstrapHelper" do
      ActionView::Base.send :include, TwitterBootstrapHelper
    end
  end
end