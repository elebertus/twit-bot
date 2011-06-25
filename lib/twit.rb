require 'twitter'

module Cinch::Plugins
  module YOURTWITTERPLUGIN 
    class TWIT

      def initialize(*args)
        super(*args)
        Twitter.configure do |config|
          config.consumer_key = 'foo'
          config.consumer_secret = 'bar'
          config.oauth_token = 'baz'
          config.oauth_token_secret = 'cha'
        end
        @twit = Twitter.new 
      end

      def post(text)
        @twit.update(text)
      end

      def get_last
       last = @twit.user_timeline("UserName", :count=> "1")
       p "http://twitter.com/#!/UserName/status/" + last.to_s.match(/([0-9]{10,20})/)[0] 
      end
    end

   class LISTEN
     include Cinch::Plugin
     
     def initialize(*args)
       super
       @twit = TWIT.new
     end

     match %r/(^http:\/\/.+|^www\..+)/, :use_prefix => false, :use_suffix => true
     react_on :channel

     def execute(m, query)
       @twit.post(query)
       m.reply "#{@twit.get_last}"
     end
   end
  end
end
