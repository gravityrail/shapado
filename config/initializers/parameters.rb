# This is a monkey-patch of
# actionpack/lib/action_dispatch/http/parameters.rb

# The env key action_dispatch.request.parameters is being set earlier
# than expected (by Rails, at least). Since the original version of
# the #parameters method memoizes the first access to params, future
# changes (to path_parameters for instance, which comes last) were not
# being carried, and in some cases params[:controller] and
# params[:action] were returning nil (among other similar errors). So
# this patch removes the memoization.

# TODO: the lack of memoization makes each access to params a little
# more expensive, and creates extra temporary hashes that have later
# to be garbage-collected, so it is important to find out how to make
# memoization work again without reintroducing the breakage described
# above.

module ActionDispatch
  module Http
    module Parameters
      # Returns both GET and POST \parameters in a single hash.
      def parameters
          params = request_parameters.merge(query_parameters)
          params.merge!(path_parameters)
          params = encode_params(params).with_indifferent_access
          @env["action_dispatch.request.parameters"] = params
      end
      alias :params :parameters
    end
  end
end
