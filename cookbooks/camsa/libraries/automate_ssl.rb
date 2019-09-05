
# Resource to patch the Automate server with the correct SSL certificate

module CAMSA
  class AutomateSSL < CAMSABase

    resource_name :automate_ssl

    # Define the path to the certificate files
    property :cert_path, String, default: lazy { '/etc/letsencrypt/live/%s/fullchain.pem' % [node['fqdn']] }
    property :cert_key_path, String, default: lazy { '/etc/letsencrypt/live/%s/privkey.pem' % [node['fqdn']] }

    # Define the path to the toml file
    property :patch_file, String, default: lazy { ::File.join(node['camsa']['dirs']['etc'], 'patch_ssl.toml') }

    # Set the name of the template to use
    property :template, String, default: 'patch_ssl.toml'

    action :run do

      if ::File.exist?(new_resource.cert_path) && ::File.exist?(new_resource.cert_key_path)

        # Get the contents of the certificate and key
        certificate = ::IO.read(new_resource.cert_path)
        certificate_key = ::IO.read(new_resource.cert_key_path)

        template new_resource.patch_file do
          source new_resource.template
          variables ({
            certificate: certificate,
            key: certificate_key,
          })

          notifies :run, 'bash[patch_automate]', :immediate
        end

        # Patch the automate server with the patch file
        bash 'patch_automate' do
          code <<-EOH
          chef-automate config patch #{new_resource.patch_file}
          EOH
        end
      else

        log 'cert_files_not_found' do
          message 'Certificate file or key file cannot be located'
          level :warn
        end
      end

    end
  end
end