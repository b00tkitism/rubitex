module Rubitex
  module Builders
    module_function

    def bool(x) = x == true || x.to_s == "true"
    def int(x)  = x.nil? ? nil : Integer(x) rescue nil
    def dec(x)  = x.nil? ? nil : x.to_s

    def bank_account(h)
      Types::BankAccount.new(
        id: int(h["id"]),
        number: h["number"],
        shaba: h["shaba"],
        bank: h["bank"],
        owner: h["owner"],
        confirmed: bool(h["confirmed"]),
        status: h["status"]
      )
    end

    def options(h)
      Types::Options.new(
        fee: dec(h["fee"]),
        fee_usdt: dec(h["feeUsdt"]),
        maker_fee: dec(h["makerFee"]),
        maker_fee_usdt: dec(h["makerFeeUsdt"]),
        is_manual_fee: bool(h["isManualFee"]),
        vip_level: int(h["vipLevel"]),
        discount: h["discount"], # could coerce if you know type
        tfa: bool(h["tfa"]),
        social_login_enabled: bool(h["socialLoginEnabled"]),
        can_set_password: bool(h["canSetPassword"]),
        whitelist: bool(h["whitelist"]),
        has_diff_claim: bool(h["hasDiffClaim"])
      )
    end

    def verifications(h)
      Types::Verifications.new(
        email: bool(h["email"]),
        phone: bool(h["phone"]),
        mobile: bool(h["mobile"]),
        identity: bool(h["identity"]),
        selfie: bool(h["selfie"]),
        auto_kyc: bool(h["auto_kyc"]),
        bank_account: bool(h["bankAccount"]),
        bank_card: bool(h["bankCard"]),
        address: bool(h["address"]),
        city: bool(h["city"]),
        phone_code: bool(h["phoneCode"]),
        mobile_identity: bool(h["mobileIdentity"]),
        national_serial_number: bool(h["nationalSerialNumber"])
      )
    end

    def pending_verifications(h)
      Types::PendingVerifications.new(
        email: bool(h["email"]),
        phone: bool(h["phone"]),
        mobile: bool(h["mobile"]),
        identity: bool(h["identity"]),
        address: bool(h["address"]),
        selfie: bool(h["selfie"]),
        auto_kyc: bool(h["auto_kyc"]),
        bank_account: bool(h["bankAccount"]),
        bank_card: bool(h["bankCard"]),
        phone_code: bool(h["phoneCode"]),
        mobile_identity: bool(h["mobileIdentity"])
      )
    end

    def trade_stats(h)
      Types::TradeStats.new(
        month_trades_total: dec(h["monthTradesTotal"]),
        month_trades_count: int(h["monthTradesCount"])
      )
    end

    def profile(h)
      Types::Profile.new(
        id: int(h["id"]),
        username: h["username"],
        email: h["email"],
        level: int(h["level"]),
        first_name: h["firstName"],
        last_name: h["lastName"],
        national_code: h["nationalCode"],
        nickname: h["nickname"],
        phone: h["phone"],
        mobile: h["mobile"],
        province: h["province"],
        city: h["city"],
        address: h["address"],
        postal_code: h["postalCode"],
        disclaimer: h["disclaimer"],
        disclaimers: h["disclaimers"], # keep as raw Hash or map if you prefer
        bank_cards: (h["bankCards"] || []), # no schema given – keep raw list
        bank_accounts: (h["bankAccounts"] || []).map { |ba| bank_account(ba) },
        payment_accounts: (h["paymentAccounts"] || []), # keep as raw list
        verifications: verifications(h["verifications"] || {}),
        pending_verifications: pending_verifications(h["pendingVerifications"] || {}),
        track: int(h["track"]),
        options: options(h["options"] || {}),
        features: (h["features"] || []),
        chat_id: h["chatId"],
        withdraw_eligible: bool(h["withdrawEligible"]),
        websocket_auth_param: h["websocketAuthParam"]
      )
    end

    def profile_response(raw)
      Types::ProfileResponse.new(
        status: raw["status"],
        profile: profile(raw["profile"] || {}),
        trade_stats: trade_stats(raw["tradeStats"] || {}),
        we_id: raw["we_id"]
      )
    end
  end
end