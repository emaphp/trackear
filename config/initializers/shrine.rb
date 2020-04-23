# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/s3'
require 'shrine/storage/file_system'

if ENV['RAILS_ENV'] == 'production'
  s3_options = {
    bucket: ENV['S3_BUCKET'],
    region: 'us-east-1',
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
  cache = Shrine::Storage::S3.new(prefix: 'uploads/cache', **s3_options)
  store = Shrine::Storage::S3.new(prefix: 'uploads', **s3_options)
else
  cache = Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache')
  store = Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
end

Shrine.storages = {
  cache: cache,
  store: store
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
