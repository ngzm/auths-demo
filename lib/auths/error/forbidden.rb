module Auths
  module Error
    #  Forbidden Error
    class Forbidden < AuthError
      def http_status
        :forbidden
      end
    end
  end
end
