resource "null_resource" "ansible_hosts_cluster_master" {
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "echo '---' | tee hosts_cluster_${count.index} ; echo 'all:' | tee -a hosts_cluster_${count.index} ; echo '  children:' | tee -a hosts_cluster_${count.index}; echo '    master:' | tee -a hosts_cluster_${count.index}; echo '      hosts:' | tee -a hosts_cluster_${count.index} ; echo '        ${vsphere_virtual_machine.master[count.index].default_ip_address}:' | tee -a hosts_cluster_${count.index}"
  }
}

resource "null_resource" "ansible_hosts_cluster_static1" {
  depends_on = [null_resource.ansible_hosts_cluster_master]
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "echo '    workers:' | tee -a hosts_cluster_${count.index} ; echo '      hosts:' | tee -a hosts_cluster_${count.index}"
  }
}

resource "null_resource" "ansible_hosts_cluster_workers" {
  depends_on = [null_resource.ansible_hosts_cluster_static1]
  count            = length(var.vmw.kubernetes.clusters) * var.vmw.kubernetes.workers.count
  provisioner "local-exec" {
    command = "echo '        ${vsphere_virtual_machine.worker[count.index].default_ip_address}:' | tee -a hosts_cluster_${floor(count.index / var.vmw.kubernetes.workers.count)}"
  }
}

resource "null_resource" "ansible_hosts_cluster_static2" {
  depends_on = [null_resource.ansible_hosts_cluster_workers]
  count            = length(var.vmw.kubernetes.clusters)
  provisioner "local-exec" {
    command = "echo '  vars:' | -a tee hosts_cluster_${count.index} ; echo '    ansible_user: ubuntu' | tee -a hosts_cluster_${count.index}; echo '    ansible_ssh_common_args: ${var.jump.private_key_path}' | tee -a hosts_cluster_${count.index}"
  }
}