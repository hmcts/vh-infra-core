variable "redis_cache_standard_sku" {
  type = map(string)

  default = {}
}

variable "default_redis_cache_standard_sku" {
  type = map(string)

  default = {
    sku_name = "Standard"
    capacity = "0"
    family   = "C"
  }
}

variable "environment_to_sku_map" {
  type = map(any)
  default = {
    AAT = {
      sku_name = "Basic"
      capacity = "0"
      family   = "C"
    }
    Dev = {
      sku_name = "Basic"
      capacity = "0"
      family   = "C"
    }
    Preview = {
      sku_name = "Basic"
      capacity = "0"
      family   = "C"
    }
    Sandbox = {
      sku_name = "Basic"
      capacity = "0"
      family   = "C"
    }
    Test1 = {
      sku_name = "Basic"
      capacity = "0"
      family   = "C"
    }
    Test2 = {
      sku_name = "Basic"
      capacity = "0"
      family   = "C"
    }
    PreProd = {
      sku_name = "Standard"
      capacity = "0"
      family   = "C"
    }
    Prod = {
      sku_name = "Standard"
      capacity = "0"
      family   = "C"
    }
  }
}

locals {
  environment = var.environment
  sku = lookup(var.environment_to_sku_map, var.environment, {
    sku_name = "Basic"
    capacity = "0"
    family   = "C"
  })
}

variable "redis_cache_enable_non_ssl_port" {
  default = false
}

variable "redis_cache_standard_maxmemory_reserved" {
  default = "50"
}

variable "redis_cache_standard_maxmemory_delta" {
  default = "50"
}

variable "redis_cache_standard_maxmemory_policy" {
  default = "volatile-lru"
}

variable "redis_cache_patch_schedule_day" {
  default = "Monday"
}

variable "redis_cache_patch_schedule_hour" {
  default = "0"
}

variable "tags" {
  type    = map(any)
  default = {}
}
