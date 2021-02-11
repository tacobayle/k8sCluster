

variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "avi_password" {}
variable "avi_username" {}
variable "avi_vsphere_user" {}
variable "avi_vsphere_password" {}
variable "avi_vsphere_server" {}
variable "docker_registry_username" {}
variable "docker_registry_password" {}
variable "docker_registry_email" {}

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

variable "vmw" {
  default = {
    name = "cloudVmw"
    kubernetes = {
      workers = {
        count = 3
      }
      clusters = [
        {
          name = "cluster1"
          username = "ubuntu"
          docker = {
            version = "5:19.03.8~3-0~ubuntu-bionic"
          }
          cni = {
            url = "https://docs.projectcalico.org/manifests/calico.yaml"
            name = "calico" # calico
          }
          master = {
            cpu = 8
            memory = 16384
            disk = 80
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
          worker = {
            cpu = 4
            memory = 8192
            disk = 40
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
        },
        {
          name = "cluster2"
          username = "ubuntu"
          docker = {
            version = "5:19.03.8~3-0~ubuntu-bionic"
          }
          cni = {
            url = "https://docs.projectcalico.org/manifests/calico.yaml"
            name = "calico" # calico
          }
          master = {
            count = 1
            cpu = 8
            memory = 16384
            disk = 80
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
          worker = {
            cpu = 4
            memory = 8192
            disk = 40
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
        },
        {
          name = "cluster3"
          username = "ubuntu"
          docker = {
            version = "5:19.03.8~3-0~ubuntu-bionic"
          }
          cni = {
            url = "https://docs.projectcalico.org/manifests/calico.yaml"
            name = "calico" # calico
          }
          master = {
            count = 1
            cpu = 8
            memory = 16384
            disk = 80
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
          worker = {
            cpu = 4
            memory = 8192
            disk = 40
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
        },
      ]
    }
  }
}