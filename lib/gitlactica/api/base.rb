module Gitlactica
  module Api
    class Base < Sinatra::Base
      enable  :sessions
      enable  :raise_errors if test?

      before do
        content_type :json
      end

      private

      def current_user
        GitHub::User.new('celluloid')
      end

      def to_json(obj)
        Yajl::Encoder.encode(obj)
      end
    end
  end
end
