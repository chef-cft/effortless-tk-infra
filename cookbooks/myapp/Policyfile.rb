# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'base'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'myapp::default'

# Specify a custom source for a single cookbook:
cookbook 'myapp', path: '.'
cookbook 'hardening', path: '../hardening'

# Policyfile defined attributes
default['myapp']['message'] = "This node was hardened by Chef. Policyfile created at #{Time.now.utc}"
