CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: "key",
    aws_secret_access_key: "secrety"
  }
  config.fog_directory = 'directory'
end