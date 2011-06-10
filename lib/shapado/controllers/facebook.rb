module Shapado
  module Controllers
    module Facebook
      protected
      def find_group_on_facebook(sr)
        if params[:group_id]
          @current_group ||= Group.find(params[:group_id])
          return
        end

        if sr.kind_of?(String)
          @signed_request = parse_signed_request(sr)
        else
          @signed_request = sr
        end

        if !@signed_request
          render :text => "sorry facebook is not working well today" and return
        end

        Rails.logger.info @signed_request.inspect

        @fb_page_id = @signed_request["page"]["id"]
        @current_group ||= Group.where(:"share.fb_page_id" => @fb_page_id, :state => "active").first

        if !@current_group && @signed_request["page"]["admin"]
          @current_user ||= User.where(:facebook_id => @signed_request["user"]["user_id"]).first

          if @current_user.authentication_token.blank?
            @current_user.reset_authentication_token
            @current_user.save(:validate => false)
          end

          render :partial => "facebook/enable_page" and return
        end

        @signed_request.delete("oauth_token")
        session[:shapado_signed_request] = @signed_request
        @current_group
      end

      def parse_signed_request(str)
        return if str.blank?

        sig, c = str.split('.')

        json = c.gsub('-','+').gsub('_','/')
        json += '=' while !(json.size % 4).zero?
        json = Base64.decode64(json)

        ActiveSupport::JSON.decode(json)
      end
    end
  end
end