variable vm_name {
  description = "Name of the Virtual Machine"
  type        = string
}

variable vm_id {
  description = "ID of the Virtual Machine"
  type        = number
}

variable cpu_cores {
  description = "Number of CPU cores for the Virtual Machine"
  type        = number
}

variable mem_dedicated {
  description = "Dedicated memory for the VM"
  type        = number
}

variable mem_floating {
  description = "Floating memory for the VM. If equal to mem_dedicated, enables ballooning"
  type        = number
}

variable vm_ip {
  description = "IPv4 address of the VM"
  type        = string
}

variable vm_bridge {
  description = "The network bridge for the VM"
  type        = string
}