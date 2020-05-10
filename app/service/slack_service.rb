# frozen_string_literal: true

class SlackService
  def self.is_request_from_slack?(request)
    secret = Rails.application.credentials.slack_signing_secret
    timestamp = request.headers['X-Slack-Request-Timestamp']
    body = request.body
    data = "v0:#{timestamp}:#{body}"
    digest = OpenSSL::Digest.new('sha256')
    hexdigest = OpenSSL::HMAC.hexdigest(digest, secret, data)
    signature = "v0=#{hexdigest}"
    slack_signature = request.headers['X-Slack-Signature']
    signature == slack_signature
  end
end
