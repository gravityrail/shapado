module Shapado
  module Controllers
    module Locale
      def self.included(base)
        base.class_eval do
          helper_method :current_languages, :find_languages, :language_conditions, :find_valid_locale
        end
      end

      def current_languages
        @current_languages ||= find_languages.join("+")
      end

      def find_languages
        @languages ||= begin
          if AppConfig.enable_i18n
            if languages = current_group.language
              languages = [languages]
            else
              if logged_in?
                languages = current_user.languages_to_filter
              elsif session["user.language_filter"]
                if session["user.language_filter"] == 'any'
                  languages = AVAILABLE_LANGUAGES
                else
                  languages = [session["user.language_filter"]]
                end
              elsif params[:mylangs]
                languages = params[:mylangs].split(' ')
              elsif params[:feed_token] && (feed_user = User.find_by_feed_token(params[:feed_token]))
                languages = feed_user.languages_to_filter
              else
                languages = [I18n.locale.to_s.split("-").first]
              end
            end
            languages
          else
            [current_group.language || AppConfig.default_language]
          end
        end
      end

      def language_conditions
        conditions = {}
        conditions[:language] = { :$in => find_languages}
        conditions
      end

      def available_locales; AVAILABLE_LOCALES; end

      def set_locale
        locale = AppConfig.default_language || 'en'
        if AppConfig.enable_i18n
          if logged_in?
            locale = current_user.language
            Time.zone = current_user.timezone || "UTC"
          elsif params[:feed_token] && (feed_user = User.find_by_feed_token(params[:feed_token]))
            locale = feed_user.language
          elsif params[:lang] =~ /^(\w\w)/
            locale = find_valid_locale($1)
          elsif request.env['HTTP_ACCEPT_LANGUAGE'] =~ /^(\w\w)/
            locale = find_valid_locale($1)
          end
        end
        I18n.locale = locale.to_s
      end

      def find_valid_locale(lang)
        case lang
          when /^es/
            'es-419'
          when /^pt/
            'pt-PT'
          when "fr"
            'fr'
          when "ja"
            'ja'
          when /^el/
            'el'
          else
            'en'
        end
      end
    end
  end
end
