package "curl"
package "git"
package "make"
package "bison"
package "gcc"
package "glibc-devel"
package "mercurial"

gvm_installer_uri  = "https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer"
file_cache_path    = Chef::Config[:file_cache_path]
gvm_installer_path = "#{file_cache_path}/gvm_installer"
install_dir        = ""

bash "install gvm" do
  if node[:gvm][:gvm_dest] == nil
    code   "bash < <(curl -s -S -L #{gvm_installer_uri})"

    install_dir = "#{Dir.home}/.gvm"
    not_if { File.exists?(install_dir) }
  else
    code <<-EOC
curl "#{gvm_installer_uri}" -o "#{gvm_installer_path}"
chmod +x "#{gvm_installer_path}"
bash "#{gvm_installer_path}" "#{node[:gvm][:branch]}" "#{node[:gvm][:gvm_dest]}"
EOC
    
    install_dir = "#{node[:gvm][:gvm_dest]}/gvm"
    not_if { File.exists?(install_dir) }
  end
end

directory install_dir do
  user      node[:gvm][:user]
  group     node[:gvm][:group]
  recursive true
end

file gvm_installer_path do
  action :delete
end

version = node[:gvm][:version]

if version
  bash "gvm install #{version}" do
    code   "gvm install #{version}"
    not_if { File.exists?("#{install_dir}/gos/#{version}") }
  end

  directory install_dir do
    user      node[:gvm][:user]
    group     node[:gvm][:group]
    recursive true
  end
end
