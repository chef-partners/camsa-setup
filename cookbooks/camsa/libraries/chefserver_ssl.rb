#
# Resource to configure the chef server with the ssl certificate that
# has been retrieved
#

module CAMSA
  class ChefServerSSL < CAMSABase

    resource_name :chefserver_ssl

    # Define the path to the certificate files
    property :cert_path, String, default: lazy { '/etc/letsencrypt/live/%s/fullchain.pem' % [node['fqdn']] }
    property :cert_key_path, String, default: lazy { '/etc/letsencrypt/live/%s/privkey.pem' % [node['fqdn']] }

    # Set the configuration file that needs to be appended to
    property :config_file, Strinf, default: '/etc/opscode/chef-server.rb'

    action :run do

      # Only proceed if the certificate and key file exist
      if ::File.exist?(new_resource.cert_path) && ::File.exist?(new_resource.cert_key_path)

        append_if_no_line "ssl_certificate" do
          path new_resource.cert_path
          line 'echo nginx["ssl_certificate"] = "%s"' % [new_resource.cert_path]
        end

        append_if_no_line "ssl_certificate_key" do
          path new_resource.cert_path
          line 'echo nginx["ssl_certificateKey"] = "%s"' % [new_resource.cert_key_path]
        end

        bash 'chef_reconfigure' do
          code "chef-server-ctl reconfigure"
          subscribes :run, "file[#{new_resource.config_file}]", :immediately
        end
      end
    end
  end
end