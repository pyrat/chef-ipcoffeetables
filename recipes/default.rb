#
# Cookbook Name:: ipcoffeetables
# Recipe:: default
#
# Copyright 2011, Alastair Brunton
#
# MIT
#


unless File.exists?("/etc/iptables.up.rules")


  execute "flush iptables rules" do
    command "/sbin/iptables -F"
    user "root"
    group "root"
  end

  template "/etc/iptables.up.rules" do
    source "iptables.up.rules.erb"
    owner "root"
    group "root"
    mode "0755"
    variables(
    :ssh_port => node["ipcoffeetables"]["ssh_port"],
    :custom_ports => node["ipcoffeetables"]["custom_ports"]
    )
  end

  execute "load rules" do
    command "/sbin/iptables-restore < /etc/iptables.up.rules"
    user "root"
    group "root"
  end

  # Startup template to load rules at reboot

  template "/etc/network/if-pre-up.d/iptables" do
    source "iptables-pre-up.erb"
    owner "root"
    group "root"
    mode "0775"
  end

end
