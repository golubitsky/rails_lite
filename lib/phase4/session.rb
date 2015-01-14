require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
        @session = {}
        cookie = req.cookies.find { |c| c.name == '_rails_lite_app' }
        @session = JSON.parse(cookie.value) if cookie
    end

    def [](key)
        @session[key]
    end

    def []=(key, val)
        @session[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
        session_json = JSON.generate(@session)
        cookie = WEBrick::Cookie.new('_rails_lite_app', session_json)
        res.cookies << cookie
    end
  end
end
