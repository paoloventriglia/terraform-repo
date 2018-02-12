# Configure the VMware vCloud Director Variable

# Provider variables

variable "vcd_user" {default = "paolo.ventriglia.local"}
variable "vcd_pass" {default = "Br19htlit3"}
variable "vcd_org" {default = "LCG-CORE-DEV"}
variable "vcd_url" {default = "https://p8v89-vcd.vchs.vmware.com/api/"}
variable "vcd_vdc" {default = "LCG-DEV-TEST"}
variable "vcd_max_retry_timeout" {default = 60}
variable "vcd_allow_unverified_ssl" {default = "true"}