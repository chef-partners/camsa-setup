# 
# Resource to download and install Lets Encrypt certificates for the servers
#
# The cookbook does not use any Lets Encrypt cookbooks because it is not possible
# to shutdown servoces when the certificate needs to be renewed. However by using
# the `certbot renew` command it is possible to add pre and post hooks to stop and
# start the service

module CAMSA
  class CAMSACertificate < CAMSABase

    resource_name :camsa_certificate

    property :start_command, String, default: ''
    property :stop_command, String, default: ''

    property :fqdn, String, default: ''
    property :email_address, String, default: ''

    property :schedule, String
    property :test, Boolean, default: false

    property :creates, String, default: lazy { ::File.join(node['camsa']['dirs']['flags'], 'certificate.flag') }

    action :run do

      # Ensure the correct packages are installed
      install_packages

      # Create the certificate
      unless new_resource.test
        create_certificate unless sentinel_file.exist?
      end

      # Create the backup script and set in the cron
      schedule_check

    end

    action_class do
      def install_packages

        # Add the Lets Encrypt packages
        apt_repository 'certbot-repo' do
          uri 'ppa:certbot/certbot'
          notifies :update, 'apt_update[update_cache]', :immediately
        end

        # Update the apt cache
        apt_update 'update_cache' do
          action :nothing
        end

        # Install necessary packages
        %w(software-properties-common certbot).each do |pkg_name|
          package pkg_name do
            action :install
          end
        end
      end

      def create_certificate

        start_command = new_resource.start_command
        stop_command = new_resource.stop_command
        fqdn = new_resource.fqdn
        email_address = new_resource.email_address

        # Use the bash resource to stop the service, get the certificate and restart the service
        bash 'get_cetificate' do
          code <<-EOH
          #{stop_command}
          certbot certonly --standalone -d #{fqdn} -m #{email_address} --agree-tos -n
          #{start_command}
          EOH
        end
      end

      def schedule_check

        start_command = new_resource.start_command
        stop_command = new_resource.stop_command

        # Use the template to create the script that will be run to renew the certificate
        filename = ::File.join(node['camsa']['dirs']['bin'], 'renew_cert.sh')
        template filename do
          source 'renew_cert.sh'
          variables ({
            stop_command: stop_command,
            start_command: start_command,
          })
          mode '0755'
        end

        # Set the renew using the cron
        timing = new_resource.schedule.split(' ')
        cron_d 'renew_certificate' do
          minute timing[0]
          hour timing[1]
          day timing[2]
          month timing[3]
          weekday timing[4]
          command filename
        end

      end

      def sentinel_file
        ::Pathname.new(Chef::Util::PathHelper.cleanpath(
          new_resource.creates
        ))
      end
    end
  end
end