

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

variable "controller" {
  default = {
    cpu = 16
    memory = 32768
    disk = 256
    count = "1"
    version = "20.1.3-9085"
    floatingIp = "10.41.134.130"
    wait_for_guest_net_timeout = 4
    private_key_path = "~/.ssh/cloudKey"
    environment = "VMWARE"
    dns =  ["10.23.108.1", "10.23.108.2"]
    ntp = ["95.81.173.155", "188.165.236.162"]
    from_email = "avicontroller@avidemo.fr"
    se_in_provider_context = "true" # true is required for LSC Cloud
    tenant_access_to_provider_se = "true"
    tenant_vrf = "false"
    aviCredsJsonFile = "~/.avicreds.json"
    public_key_path = "~/.ssh/cloudKey.pub"
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
    aviPbAbsentUrl = "https://github.com/tacobayle/ansiblePbAviAbsent"
    aviPbAbsentTag = "v1.48"
    aviConfigureUrl = "https://github.com/tacobayle/aviConfigure"
    aviConfigureTag = "v4.16"
    version = "2.9.12"
    opencartInstallUrl = "https://github.com/tacobayle/ansibleOpencartInstall"
    opencartInstallTag = "v1.21"
    directory = "ansible"
    k8sInstallUrl = "https://github.com/tacobayle/ansibleK8sInstall"
    k8sInstallTag = "v1.54"
  }
}

variable "vmw" {
  default = {
    name = "cloudVmw"
    network_vip = {
      name = "vxw-dvs-34-virtualwire-118-sid-1080117-sof2-01-vc08-avi-dev114"
      ipStartPool = "50"
      ipEndPool = "99"
      cidr = "100.64.131.0/24"
      type = "V4"
      exclude_discovered_subnets = "true"
      vcenter_dvs = "true"
      dhcp_enabled = "no"
    }
    kubernetes = {
      ako = {
        helm = {
          url = "https://avinetworks.github.io/avi-helm-charts/charts/stable/ako"
        }
      }
      workers = {
        count = 3
      }
      clusters = [
        {
          name = "cluster1" # cluster name
          netplanApply = true
          username = "ubuntu" # default username dor docker and to connect
          ako = {
            namespace = "avi-system"
          }
          version = "1.18.2-00" # k8s version
          arePodsReachable = "false" # defines in values.yml if dynamic route to reach the pods
          serviceEngineGroup = {
            name = "seg-cluster1"
            ha_mode = "HA_MODE_SHARED"
            min_scaleout_per_vs = "2"
            vcenter_folder = "NicTfVmw"
          }
          networks = {
            pod = "192.168.0.0/16"
          }
          docker = {
            version = "5:19.03.8~3-0~ubuntu-bionic"
          }
          service = {
            type = "ClusterIP"
          }
          interface = "ens224" # interface used by k8s
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
          netplanApply = true
          username = "ubuntu"
          ako = {
            namespace = "avi-system"
          }
          version = "1.18.2-00"
          arePodsReachable = "false"
          serviceEngineGroup = {
            name = "seg-cluster2"
            ha_mode = "HA_MODE_SHARED"
            min_scaleout_per_vs = "2"
            vcenter_folder = "NicTfVmw"
          }
          networks = {
            pod = "192.168.1.0/16"
          }
          docker = {
            version = "5:19.03.8~3-0~ubuntu-bionic"
          }
          service = {
            type = "ClusterIP"
          }
          interface = "ens224"
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
          netplanApply = true
          username = "ubuntu"
          ako = {
            namespace = "avi-system"
          }
          version = "1.18.2-00"
          arePodsReachable = "false"
          serviceEngineGroup = {
            name = "seg-cluster3"
            ha_mode = "HA_MODE_SHARED"
            min_scaleout_per_vs = "2"
            vcenter_folder = "NicTfVmw"
          }
          networks = {
            pod = "192.168.2.0/16"
          }
          docker = {
            version = "5:19.03.8~3-0~ubuntu-bionic"
          }
          service = {
            type = "ClusterIP"
          }
          interface = "ens224"
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