#!/bin/bash
echo "pkg_origin is $1"
echo "pkg_name is $2"
export HAB_LICENSE="accept-no-persist"

if [ ! -e "/bin/hab" ]; then
  curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
fi

if grep "^hab:" /etc/passwd > /dev/null; then
  echo "Hab user exists"
else
  useradd hab && true
fi

if grep "^hab:" /etc/group > /dev/null; then
  echo "Hab group exists"
else
  groupadd hab && true
fi

results_folder="/tmp/habitat/results"
pkg_origin=$1
pkg_name=$2

export HAB_ORIGIN=orgname
cd /tmp/habitat
hab pkg install core/hab-studio
hab origin key generate
hab studio run build

echo "Building $pkg_origin/$pkg_name"

latest_hart_file=$(ls -1art $results_folder/$pkg_origin-$pkg_name* |tail -1)
echo "Latest hart file is $latest_hart_file"

echo "Installing $latest_hart_file"
hab pkg install $latest_hart_file

echo "Determing pkg_prefix for $latest_hart_file"
# pkg_prefix=$(find /hab/pkgs/$pkg_origin/chef-base -maxdepth 2 -mindepth 2 | sort | tail -n 1)
pkg_prefix=$(find /hab/pkgs/$pkg_origin/$pkg_name -maxdepth 2 -mindepth 2 | sort | tail -n 1)

echo "Found $pkg_prefix"

echo "{\"bootstrap_mode\": true}" > $results_folder/bootstrap.json

echo "Running chef for $pkg_origin/$pkg_name"
cd $pkg_prefix
if [ -n "$bootstrap" ]; then
  hab pkg exec $pkg_origin/$pkg_name chef-client -z -j $results_folder/bootstrap.json -c $pkg_prefix/config/bootstrap-config.rb
else
  hab pkg exec $pkg_origin/$pkg_name chef-client -z -c $pkg_prefix/config/bootstrap-config.rb
fi

rm $results_folder/bootstrap.json
