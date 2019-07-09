{
  storageAccountName: "<%= @sa_name %>",
  storageAccountKey: "<%= @access_key %>",
  queueName: "chef-statsd",
  backends: [ "<%= @plugin %>" ]
}