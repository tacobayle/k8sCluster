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
    command = "echo '  vars:' | tee -a hosts_cluster_${count.index} ; echo '    ansible_user: ${var.vmw.kubernetes.clusters[count.index].username}' | tee -a hosts_cluster_${count.index}; echo '    ansible_ssh_common_args: ${var.jump.private_key_path}' | tee -a hosts_cluster_${count.index}"
  }
}


resource "null_resource" "ansible_bootstrap1" {
  depends_on = [null_resource.ansible_hosts_cluster_static2, vsphere_virtual_machine.jump]
  connection {
    host = vsphere_virtual_machine.jump.default_ip_address
    type = "ssh"
    agent = false
    user = var.jump.username
    private_key = file(var.jump.private_key_path)
  }

  provisioner "file" {
    source      = var.jump.private_key_path
    destination = "~/.ssh/${basename(var.jump.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/.ssh/${basename(var.jump.private_key_path)}"
    ]
  }
}

resource "null_resource" "ansible_bootstrap2" {
  depends_on = [null_resource.ansible_bootstrap1]
  count = length(var.vmw.kubernetes.clusters)
  connection {
    host = vsphere_virtual_machine.jump.default_ip_address
    type = "ssh"
    agent = false
    user = var.jump.username
    private_key = file(var.jump.private_key_path)
  }

  provisioner "file" {
    source = "hosts_cluster_${count.index}"
    destination = "hosts_cluster_${count.index}"
  }

  provisioner "remote-exec" {
    inline = [
      "git clone ${var.ansible.k8sInstallUrl} --branch ${var.ansible.k8sInstallTag} ; ansible-playbook -i hosts_cluster_${count.index} ${basename(var.ansible.k8sInstallUrl)}/main.yml --extra-vars '{\"kubernetes\": ${jsonencode(var.vmw.kubernetes.clusters[count.index])}}'"
    ]
  }
}