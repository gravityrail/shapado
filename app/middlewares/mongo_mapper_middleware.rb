class MongoidMiddleware
  def initialize(app)
    @app = app
  end

  def clear_descendants(k)
    return unless k.respond_to?(:descendants)
    k.descendants do |d|
      clear_descendants(d)
    end
    k.descendants.clear
  end

  def call(env)
    if Rails.configuration.cache_classes
      Mongoid::Plugins::IdentityMap.clear
    else
      clear_descendants(Mongoid::Document)
      clear_descendants(Mongoid::EmbeddedDocument)
      Mongoid::Plugins::IdentityMap.clear
      Mongoid::Plugins::IdentityMap.models.clear
    end

    @app.call(env)
  end
end
