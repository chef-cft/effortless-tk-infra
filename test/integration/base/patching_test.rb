# # encoding: utf-8

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/hab/svc/base/data/cache/cache/chef_patching_sentinel') do
  it { should exist }
end
