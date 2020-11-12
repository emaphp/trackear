Pay.setup do |config|
  config.send_emails = true
  config.automount_routes = true
  config.routes_path = "/pay" # Only when automount_routes is true
end
