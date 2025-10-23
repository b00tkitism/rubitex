module Rubitex
  module API
    def login(otp: 0)
      raise ArgumentError, "invalid otp" unless otp.to_s.match?(/\A\d{6}\z/)
      return @api_token if @api_token

      body = {
        username: @username,
        password: @password,
        captcha:  "api",
        remember: (@remember ? "yes" : "no")
      }

      additional_headers = { "X-TOTP" => otp.to_s }

      data = post_json("auth/login/", body, authenticate: false, headers: additional_headers)

      if data["status"] == "success" && data["key"].to_s != ""
        @api_token = data["key"]
      else
        raise "Login failed: #{data.inspect}"
      end
    end

    # @return [Rubitex::Types::ProfileResponse]
    def profile
      Rubitex::Builders.profile_response(get("users/profile", authenticate: true))
    end

    def balance(currency: "rls")
      post_json("/users/wallets/balance", {"currency": currency}, authenticate: true, headers: {})["balance"].to_f
    end
  end
end

Rubitex::Client.include(Rubitex::API)