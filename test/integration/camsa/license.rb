customer_name = input('customer_name', value: '')

# Check that the license has been applied properly and registered with the correct user
cmd = 'curl https://127.0.0.1/api/v0/license/status -k --cert /hab/svc/deployment-service/data/deployment-service.crt --key /hab/svc/deployment-service/data/deployment-service.key --cacert /hab/svc/deployment-service/data/root.crt'
describe json({command: cmd}) do
  its ('customer_name') { should include customer_name }
end

# Ensure the user exists in automate
cmd = 'curl https://127.0.0.1/api/v0/auth/users -k --cert /hab/svc/deployment-service/data/deployment-service.crt --key /hab/svc/deployment-service/data/deployment-service.key --cacert /hab/svc/deployment-service/data/root.crt'
describe json({command: cmd}) do
  its (['users', 1, 'name']) { should include customer_name }
end