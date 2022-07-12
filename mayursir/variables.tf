
##############################################################
# igw -tag
##############################################################
variable "igw_tag" {
  description = "Mention Tag needs to be associated with internet gateway"
  type        = string
  default     = "my_igw"
}

##################################################################
# public-rout-table-tag
##################################################################

variable "public_route_table_tag" {
  description = "Tag name for public route table"
  type        = string
  default     = "route_table-2"
}
variable "database_route_table_tag" {
  description = "Tage for database route table"
  type        = string
  default     = "route_table-1"
}

###################################################################
#  cidr-rang-vpc
###################################################################
variable "cidr" {
  description = "Enter the CIDR range required for VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "vpc_name" {
  description = "Tag Name to be assigned with VPC"
  type        = string
  default     = "my-vpc-main"
}

variable "default_security_group_name" {
  description = "Enter the name for security group"
  type        = string
  default     = "my-sg"
}

variable "enable_dhcp_options" {
  description = "Enable DHCP  True "
  type        = bool
  default     = null
}

variable "manage_default_route_table" {
  description = "do not manage default RT"
  type        = bool
  default     = null
}
variable "public_subnet_tag_1" {
  description = "Tag for public subnet"
  type        = string
  default     = "public_subnet_az_1a"
}
variable "public_subnet_tag_2" {
  description = "Tag for public subnet"
  type        = string
  default     = "public_subnet_az_1b"
}
variable "public_subnet" {
  description = "enter the number of public subnets you need"
  type        = number
  default     = null
}

variable "public_subnets_cidr_1" {
  description = "Cidr Blocks"
  type        = string
  default     = "10.0.1.0/24"
}
variable "public_subnets_cidr_2" {
  description = "Cidr Blocks"
  type        = string
  default     = "10.0.2.0/24"
}
variable "database_subnet_tag_1" {
  description = "Tag for Private Subnet"
  type        = string
  default     = "database_subnet_az_1a"
}
variable "database_subnet_tag_2" {
  description = "Tag for Private Subnet"
  type        = string
  default     = "database_subnet_az_1b"
}

variable "database_subnets_cidr_1" {
  description = "mention the CIDR block for database subnet"
  type        = string
  default     = "10.0.5.0/24"
}
variable "database_subnets_cidr_2" {
  description = "mention the CIDR block for database subnet"
  type        = string
  default     = "10.0.6.0/24"
}
variable "sg-description" {
  type    = string
  default = "http,ssh,https"

}
variable "rout-destinetion-igw" {
  type = string
  default = "0.0.0.0/0"
  
}

#####################################################################
# EC2-variable 
#####################################################################


variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "associate_public_ip" {
  type    = bool
  default = true
}
variable "az" {
  type    = string
  default = "us-east-1a"
}

variable "key" {
  type    = string
  default = "dev-account"
}

variable "volume_size" {
  type    = number
  default = 10
}
variable "application" {
  type    = string
  default = "tcw"
}
variable "organization" {
  type    = string
  default = "thecloudworld"
}