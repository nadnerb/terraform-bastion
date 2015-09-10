output "bastion server public ips a"{
  value = "${module.bastion_servers_a.public-ips}"
}

output "bastion server public ips b"{
  value = "${module.bastion_servers_b.public-ips}"
}
