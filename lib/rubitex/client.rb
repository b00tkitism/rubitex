require "net/http"
require "json"
require "uri"

module Rubitex
  API_URL = "https://apiv2.nobitex.ir/"

  class Client
    attr_reader :api_token, :get_headers, :post_headers

    def initialize(username: nil, password: nil, api_token: nil,
                   user_agent: "TraderBot/MyBot123", remember: true, timeout: 10)
      if api_token.nil?
        raise ArgumentError, "username and password required if api_token not provided" \
          if username.to_s.empty? || password.to_s.empty?
      end
      raise ArgumentError, "User-Agent must start with 'TraderBot/'" unless user_agent.start_with?("TraderBot/")

      @username   = username
      @password   = password
      @api_token  = api_token
      @user_agent = user_agent
      @remember   = remember
      @timeout    = timeout

      @get_headers  = { "User-Agent" => @user_agent }
      @post_headers = @get_headers.merge("Content-Type" => "application/json")
    end

    private def is_authenticated!
      raise StandardError, "not authenticated" if @api_token.to_s.empty?
    end

    private def http(method:, endpoint:, params: nil, json: nil,
                     authenticate: false, headers: {}, parse_json: true)
      uri = URI.join(API_URL, endpoint)

      # attach query params
      if params && !params.empty?
        q = URI.encode_www_form(params)
        uri.query = [uri.query, q].compact.join("&")
      end

      base_headers = (method == :get ? @get_headers : @post_headers)
      hdrs = base_headers.merge(headers.transform_keys(&:to_s))

      if authenticate
        is_authenticated!
        hdrs["Authorization"] = "Token #{@api_token}" # mutate; don't forget!
      end

      req = case method
            when :get    then Net::HTTP::Get.new(uri, hdrs)
            when :post   then Net::HTTP::Post.new(uri, hdrs)
            when :put    then Net::HTTP::Put.new(uri, hdrs)
            when :patch  then Net::HTTP::Patch.new(uri, hdrs)
            when :delete then Net::HTTP::Delete.new(uri, hdrs)
            else raise ArgumentError, "unsupported method: #{method.inspect}"
            end

      if json
        req.body = JSON.dump(json)
        req["Content-Type"] ||= "application/json"
      end

      res = Net::HTTP.start(
        uri.host, uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: @timeout,
        read_timeout: @timeout
      ) { |http| http.request(req) }

      unless res.is_a?(Net::HTTPSuccess)
        raise "HTTP #{res.code}: #{res.body}"
      end

      return nil if res.code == "204"
      parse_json ? JSON.parse(res.body) : res.body
    end

    private def get(endpoint, params: {}, authenticate: false, headers: {})
      http(method: :get,
           endpoint: endpoint,
           params: params,
           authenticate: authenticate,
           headers: headers,
           parse_json: true)
    end

    private def post_json(endpoint, data, authenticate: false, headers: {})
      http(method: :post,
           endpoint: endpoint,
           json: data,
           authenticate: authenticate,
           headers: headers,
           parse_json: true)
    end
  end
end
