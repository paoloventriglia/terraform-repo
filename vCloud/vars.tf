# Configure the VMware vCloud Director Variable

# Provider variables

variable "vcd_user" {default = ""}
variable "vcd_pass" {default = ""}
variable "vcd_org" {default = ""}
variable "vcd_url" {default = "https://xxxxxxx.vchs.vmware.com/api/"}
variable "vcd_vdc" {default = ""}
variable "vcd_max_retry_timeout" {default = 60}
variable "vcd_allow_unverified_ssl" {default = "true"}