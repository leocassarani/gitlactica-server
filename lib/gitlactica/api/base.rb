module Gitlactica
  module Api
    class Base < Sinatra::Base
      disable :show_exceptions

      before do
        content_type :json
      end

      get '/repos' do
        repos = GitHub::Repo.all_by_user(current_user)
        to_json(repos.map(&:to_h))
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
