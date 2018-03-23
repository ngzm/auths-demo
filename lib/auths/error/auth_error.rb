module Auths
  module Error
    # Authentication Error
    class AuthError < RuntimeError
      def http_status
        :unauthorized
      end

      def error_level
        'warning'
      end
    end
  end
end
