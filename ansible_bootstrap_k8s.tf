resource "null_resource" "ansible_hosts_cluster_master" {
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "tee hosts_cluster_${count.index} > /dev/null <<EOT\n---\nall:\n  children:\n    master:\n      hosts:\n        ${vsphere_virtual_machine.master[count.index].default_ip_address}:"
  }
}

resource "null_resource" "ansible_hosts_cluster_workers" {
  count            = length(var.vmw.kubernetes.clusters) * var.vmw.kubernetes.workers.count
  provisioner "local-exec" {
    command = "tee -a hosts_cluster_${floor(count.index / var.vmw.kubernetes.workers.count)} > /dev/null <<EOT    workers:\n      hosts:\n        ${vsphere_virtual_machine.worker[count.index].default_ip_address}:"
  }
}
