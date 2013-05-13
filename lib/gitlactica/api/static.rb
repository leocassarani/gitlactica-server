module Gitlactica
  module Api
    class Static < Sinatra::Base
      set :public_folder, File.expand_path('../../../../public', __FILE__)

      get '/' do
        redirect '/index.html'
      end
    end
  end
end