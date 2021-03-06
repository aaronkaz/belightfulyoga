CarrierWave.configure do |config|

  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['S3_KEY'],       # required
    :aws_secret_access_key  => ENV['S3_SECRET'],       # required
    :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
  }

  config.fog_directory  = ENV['S3_BUCKET']                     # required
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  #config.asset_host     = 'https://assets.example.com'            # optional, defaults to nil
  
  
    
end

storage = Fog::Storage.new(
    :provider               => 'AWS',       # required
    :aws_access_key_id      => ENV['S3_KEY'],       # required
    :aws_secret_access_key  => ENV['S3_SECRET'],       # required
    :region                 => 'us-east-1'
)
storage.sync_clock