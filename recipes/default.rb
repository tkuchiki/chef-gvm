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

bash "install gvm" do
  if node[:gvm][:gvm_dest] == nil
    code   "bash < <(curl -s -S -L #{gvm_installer_uri})"
    not_if { File.exists?("#{Dir.home}/.gvm") }
  else
    code <<-EOC
curl #{gvm_installer_uri} -o "#{gvm_installer_path}"
chmod +x "#{gvm_installer_path}"
bash "#{gvm_installer_path}" "#{node[:gvm][:branch]}" "#{node[:gvm][:gvm_dest]}"
EOC
    not_if { File.exists?("#{node[:gvm][:gvm_dest]}/gvm") }
  end
end

file gvm_installer_path do
  action :delete
end
