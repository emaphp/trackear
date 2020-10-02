# Upload ssl certificates to the server
# based on the stage being deployed
namespace :deploy do
  namespace :check do
    before :linked_files, :upload_certs do
      on roles(:app), in: :sequence, wait: 10 do
        upload! "cert/#{fetch :stage}/fullchain.pem", fetch(:nginx_ssl_certificate)
        upload! "cert/#{fetch :stage}/privkey.pem", fetch(:nginx_ssl_certificate_key)
      end
    end
  end
end
