module Rubitex
  module Types
    BankAccount = Data.define(
      :id, :number, :shaba, :bank, :owner, :confirmed, :status
    )

    Options = Data.define(
      :fee, :fee_usdt, :maker_fee, :maker_fee_usdt, :is_manual_fee, :vip_level,
      :discount, :tfa, :social_login_enabled, :can_set_password, :whitelist, :has_diff_claim
    )

    Verifications = Data.define(
      :email, :phone, :mobile, :identity, :selfie, :auto_kyc, :bank_account,
      :bank_card, :address, :city, :phone_code, :mobile_identity, :national_serial_number
    )

    PendingVerifications = Data.define(
      :email, :phone, :mobile, :identity, :address, :selfie, :auto_kyc, :bank_account,
      :bank_card, :phone_code, :mobile_identity
    )

    TradeStats = Data.define(:month_trades_total, :month_trades_count)

    Profile = Data.define(
      :id, :username, :email, :level,
      :first_name, :last_name, :national_code, :nickname, :phone, :mobile,
      :province, :city, :address, :postal_code,
      :disclaimer, :disclaimers,            # keep disclaimers as raw Hash if you like
      :bank_cards, :bank_accounts, :payment_accounts, # arrays
      :verifications, :pending_verifications,
      :track, :options, :features, :chat_id, :withdraw_eligible, :websocket_auth_param
    )

    ProfileResponse = Data.define(:status, :profile, :trade_stats, :we_id)
  end
end