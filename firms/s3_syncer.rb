require 'aws-sdk-s3'

class S3Syncer
  def initialize(access_key_id=nil, secret_access_key=nil, region=nil, bucket_name=nil, local_directory=nil)
    @access_key_id     = access_key_id || "AKIAZBWNXOETXNQVQHTA"
    @secret_access_key = secret_access_key || "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"
    @region            = region || 'us-east-2'
    @bucket_name       = bucket_name || 'law-scraper-html'
    @local_directory   = local_directory || 'export'
  end

  def sync_to_s3
    puts "Syncing to S3 bucket #{@bucket_name}"
    s3_client = Aws::S3::Client.new( access_key_id: @access_key_id, secret_access_key: @secret_access_key, region: @region)

    s3_resource = Aws::S3::Resource.new(client: s3_client)
    bucket = s3_resource.bucket(@bucket_name)

    existing_files = Set.new
    bucket.objects.each do |obj|
      existing_files << obj.key
    end

    Dir.glob(File.join(@local_directory, '**', '*')).each do |file_path|
      next if File.directory?(file_path)

      relative_path = file_path.sub(@local_directory + '/', '')
      object_key    = relative_path

      next if existing_files.include?(object_key)

      bucket.object(object_key).upload_file(file_path)
      puts "Uploaded #{file_path} to S3 bucket #{@bucket_name} with key #{object_key}"
    end

    puts "Done syncing to S3 bucket #{@bucket_name}"
  end
end
