resource "vcd_vapp" "paolo_test5" {
  name          = "paolo_test5"
  catalog_name  = "PublishedCatalog"
  template_name = "CentOS64_Template"
  memory        = 2048
  cpus          = 1
  metadata {
    role    = "test"
    env     = "dev"
    version = "v1"
  }

  ovf {
    hostname = "test"
  }
}

