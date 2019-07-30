# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name "base"

# Where to find external cookbooks:
default_source :supermarket
default_source :chef_repo, "../"

# run_list: chef-client will run these recipes in the order specified.
run_list ["myapp::default",
          "patching::default",
          "hardening::default"]

default['hardening'] = { }

default['patching'] = { }

default['applications'] = {
  'linux' => {
  },
  'windows' => {}
}

default['myapp']['message'] = "This node was hardened by Chef Infra. Policyfile created at #{Time.now.utc}\n"
