resource "null_resource" "ansible_hosts_cluster_master" {
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "tee hosts_cluster_${count.index} > /dev/null <<EOT\n---\nall:\n  children:\n    master:\n      hosts:\n        ${vsphere_virtual_machine.master[count.index].default_ip_address}:\nEOT"
  }
}

resource "null_resource" "ansible_hosts_cluster_static1" {
  depends_on = [null_resource.ansible_hosts_cluster_master]
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "tee -a hosts_cluster_${count.index} > /dev/null <<EOT\n    workers:\n      hosts:\nEOT"
  }
}

resource "null_resource" "ansible_hosts_cluster_workers" {
  depends_on = [null_resource.ansible_hosts_cluster_static1]
  count            = length(var.vmw.kubernetes.clusters) * var.vmw.kubernetes.workers.count
  provisioner "local-exec" {
    command = "tee -a hosts_cluster_${floor(count.index / var.vmw.kubernetes.workers.count)} > /dev/null <<EOT        ${vsphere_virtual_machine.worker[count.index].default_ip_address}:\nEOT"
  }
}

resource "null_resource" "ansible_hosts_cluster_static2" {
  depends_on = [null_resource.ansible_hosts_cluster_workers]
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "tee -a hosts_cluster_${count.index} > /dev/null <<EOT  vars\n    ansible_user:  ubuntu\n    ansible_ssh_private_key_file: ${var.jump.private_key_path} \n    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'\nEOT"
  }
}