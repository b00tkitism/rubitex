require 'rotp'

module Rubitex
  class Utils
    def self.generate_otp(secret)
      ROTP::TOTP.new(secret, issuer: "Rubitex").now
    end
  end
end