#!/usr/bin/env ruby

require 'rubygems'
require 'aws/s3'

require 'yaml'

bucket = 'ECE'
test = 5

creds_file_name = 'creds.yaml'

creds = YAML.load_file(creds_file_name)

access_key = creds['access_key']
secret_key = creds['secret_key']

AWS::S3::Base.establish_connection!(
    :access_key_id     => access_key,
    :secret_access_key => secret_key
)

puts 'testing'

objects = AWS::S3::Bucket.objects bucket

objects.each do |object|

puts object.key
puts object.metadata['x-amz-meta-securitylevel']
open(object.key , 'w') do |file|
	AWS::S3::S3Object.stream(object.key, bucket)	do |chunk|
		file.write chunk
	end	
end
end 