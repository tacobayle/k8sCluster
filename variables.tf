#
# Environment Variables
#
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "docker_registry_username" {}
variable "docker_registry_password" {}
variable "docker_registry_email" {}

#
# Other Variables
#
variable "vcenter" {
  type = map
  default = {
    dc = "sof2-01-vc08"
    cluster = "sof2-01-vc08c01"
    datastore = "sof2-01-vc08c01-vsan"
    resource_pool = "sof2-01-vc08c01/Resources"
    folder = "NicTfK8s"
    networkMgmt = "vxw-dvs-34-virtualwire-3-sid-1080002-sof2-01-vc08-avi-mgmt"
  }
}

variable "jump" {
  type = map
  default = {
    name = "jump"
    cpu = 2
    memory = 4096
    disk = 20
    public_key_path = "~/.ssh/cloudKey.pub"
    private_key_path = "~/.ssh/cloudKey"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    avisdkVersion = "18.2.9"
    username = "ubuntu"
  }
}

variable "ansible" {
  type = map
  default = {
    version = "2.9.12"
    directory = "ansible"
    k8sInstallUrl = "https://github.com/tacobayle/ansibleK8sInstall"
    k8sInstallTag = "v1.45"
  }
}

variable "master" {
  type = map
  default = {
    count = 1
    cpu = 8
    memory = 16384
    disk = 80
    network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
    wait_for_guest_net_routable = "false"
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    username = "ubuntu"
  }
}

variable "worker" {
  type = map
  default = {
    count = 2
    cpu = 4
    memory = 8192
    disk = 40
    network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
    wait_for_guest_net_routable = "false"
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    username = "ubuntu"
  }
}

variable "kubernetes" {
  default = {
    domain = "ako.avidemo.fr"
    ifApi = "ens224"
    dockerUser = "ubuntu"
    dockerVersion = "5:19.03.8~3-0~ubuntu-bionic"
    podNetworkCidr = "192.168.0.0/16"
    cniUrl = "https://docs.projectcalico.org/manifests/calico.yaml" # calico: https://docs.projectcalico.org/manifests/calico.yaml # flannel: https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml with 1.18.2-00
    version = "1.18.2-00"
    networkPrefix = "/24"
    deployments = [
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV1.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV2.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV3.yml"
      }
    ]
    nfs = [
      {
        name = "nfs-opencart"
      },
      {
        name = "nfs-mariadb"
      }
    ]
    services = [
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV1.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV2.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV1.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV2.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV1.yml"
      },
      {
        url = "https://raw.githubusercontent.com/tacobayle/k8sYaml/master/k8sDeploymentBusyBoxFrontEndV2.yml"
      }
    ]
  }
}