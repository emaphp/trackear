# Small little task for nvm to work on the server
# https://github.com/koenpunt/capistrano-nvm/issues/25#issuecomment-321570172
namespace :nvm do
  namespace :webpacker do
    task :validate => [:'nvm:map_bins'] do
      on release_roles(fetch(:nvm_roles)) do
        within release_path do
          if !test('node', '--version')
            warn "node is not installed"
            exit 1
          end

          if !test('yarn', '--version')
            warn "yarn is not installed"
            exit 1
          end
        end
      end
    end

    task :wrap => [:'nvm:map_bins'] do
      on roles(:web) do
        SSHKit.config.command_map.prefix['rake'].unshift(nvm_prefix)
      end
    end

    task :unwrap do
      on roles(:web) do
        SSHKit.config.command_map.prefix['rake'].delete(nvm_prefix)
      end
    end

    def nvm_prefix
      fetch(
        :nvm_prefix, -> {
          "#{fetch(:tmp_dir)}/#{fetch(:application)}/nvm-exec.sh"
        }
      )
    end

    after 'nvm:validate', 'nvm:webpacker:validate'
    before 'deploy:assets:precompile', 'nvm:webpacker:wrap'
    after 'deploy:assets:precompile', 'nvm:webpacker:unwrap'
  end
end
