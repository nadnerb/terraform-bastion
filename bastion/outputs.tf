output "public-ips" {
  value = "${join(",", aws_instance.bastion.*.public_ip)}"
}

output "bastion-ids" {
  value = "${join(",", aws_instance.bastion.*.id)}"
}
