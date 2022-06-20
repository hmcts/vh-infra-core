# General

variable "control_vault" {
  type = string
}

variable "project" {
  type = string
}

variable "product" {
  type = string
}

variable "builtFrom" {
  type = string
}

### The defaults need to be removed once up and running
variable "environment" {
  type = string
}

variable "activity_name" {
  type    = string
  default = "VH"
}

# # DNS
# variable "dns_zone_name" {
#   type = string
# }

# variable "dns_resource_group" {
#   type = string
# }

variable "dev_group" {
  type        = string
  default     = "dcd_videohearings"
  description = "specifies group to which permissions will be assigned when deploying the dev environment"
}



#########################################################

locals {
  environment   = var.environment
  suffix        = "-${local.environment}"
  common_prefix = "infra-core"
  std_prefix    = "vh-${local.common_prefix}"
  sds_domain    = ".platform.hmcts.net"

  #  prod_cnames = [
  #    {
  #      name        = "video",
  #      destination = "vh-video-web${local.suffix}.hearings.reform.hmcts.net"
  #      app         = "vh-video-web${local.suffix}"
  #      fqdn        = "video.hearings.reform.hmcts.net"
  #    },
  #    {
  #      name        = "admin",
  #      destination = "vh-admin-web${local.suffix}.hearings.reform.hmcts.net"
  #      app         = "vh-admin-web${local.suffix}"
  #      fqdn        = "admin.hearings.reform.hmcts.net"
  #    },
  #    {
  #      name        = "service",
  #      destination = "vh-service-web${local.suffix}.hearings.reform.hmcts.net"
  #      app         = "vh-service-web${local.suffix}"
  #      fqdn        = "service.hearings.reform.hmcts.net"
  #    }
  #  ]
  #
  #  test_endpoints = {
  #    admin-web-public = {
  #      public_fqdn = "vh-admin-web${local.suffix}.hearings.reform.hmcts.net"
  #    }
  #    service-web-public = {
  #      public_fqdn = "vh-service-web${local.suffix}.hearings.reform.hmcts.net"
  #    }
  #    video-web-public = {
  #      public_fqdn = "vh-video-web${local.suffix}.hearings.reform.hmcts.net"
  #    }
  #    admin-web = {
  #      public_fqdn = "vh-admin-web${local.suffix}.azurewebsites.net"
  #    }
  #    service-web = {
  #      public_fqdn = "vh-service-web${local.suffix}.azurewebsites.net"
  #    }
  #    video-web = {
  #      public_fqdn = "vh-video-web${local.suffix}.azurewebsites.net"
  #    }
  #    bookings-api = {
  #      public_fqdn = "vh-bookings-api${local.suffix}.azurewebsites.net"
  #    }
  #    user-api = {
  #      public_fqdn = "vh-user-api${local.suffix}.azurewebsites.net"
  #    }
  #    video-api = {
  #      public_fqdn = "vh-video-api${local.suffix}.azurewebsites.net"
  #    }
  #  }
  #
  #  app_definitions = {
  #    admin-web = {
  #      name            = "vh-admin-web${local.suffix}"
  #      websockets      = false
  #      ip_restriction  = var.build_agent_vnet
  #      subnet          = "backend"
  #      audience_subnet = "frontend"
  #      url             = "https://vh-admin-web${local.suffix}.hearings.reform.hmcts.net"
  #    }
  #    service-web = {
  #      name            = "vh-service-web${local.suffix}"
  #      websockets      = false
  #      ip_restriction  = var.build_agent_vnet
  #      subnet          = "backend"
  #      audience_subnet = "frontend"
  #      url             = "https://vh-service-web${local.suffix}.hearings.reform.hmcts.net"
  #    }
  #    video-web = {
  #      name            = "vh-video-web${local.suffix}"
  #      websockets      = true
  #      ip_restriction  = var.build_agent_vnet
  #      subnet          = "backend"
  #      audience_subnet = "frontend"
  #      url             = "https://vh-video-web${local.suffix}.hearings.reform.hmcts.net"
  #    }
  #    bookings-api = {
  #      name            = "vh-bookings-api${local.suffix}"
  #      websockets      = false
  #      ip_restriction  = var.build_agent_vnet
  #      subnet          = "backend"
  #      audience_subnet = "backend"
  #      url             = "https://vh-bookings-api${local.suffix}.azurewebsites.net"
  #    }
  #    user-api = {
  #      name            = "vh-user-api${local.suffix}"
  #      websockets      = false
  #      ip_restriction  = var.build_agent_vnet
  #      subnet          = "backend"
  #      audience_subnet = "backend"
  #      url             = "https://vh-user-api${local.suffix}.azurewebsites.net"
  #    }
  #    video-api = {
  #      name            = "vh-video-api${local.suffix}"
  #      websockets      = false
  #      ip_restriction  = var.build_agent_vnet
  #      subnet          = "backend"
  #      audience_subnet = "backend"
  #      url             = "https://vh-video-api${local.suffix}.azurewebsites.net"
  #    }
  #  }
  #
  #  funcapp_definitions = {
  #    booking-queue = {
  #      name            = "vh-booking-queue${local.suffix}"
  #      subnet          = "backend"
  #      audience_subnet = "backend"
  #      url             = "https://vh-booking-queue-subscriber${local.suffix}.azurewebsites.net"
  #    },
  #    scheduler-jobs = {
  #      name            = "vh-scheduler-jobs${local.suffix}"
  #      subnet          = "backend"
  #      audience_subnet = "backend"
  #      url             = "https://vh-scheduler-jobs${local.suffix}.azurewebsites.net"
  #    }
  #  }
  #
  #  app_registrations = merge(
  #    {
  #      for def in keys(local.app_definitions) :
  #      def => {
  #        name     = local.app_definitions[def].name
  #        url      = local.app_definitions[def].url
  #        audience = local.app_definitions[def].audience_subnet
  #      }
  #    },
  #    {
  #      for def in keys(local.funcapp_definitions) :
  #      def => {
  #        name     = local.funcapp_definitions[def].name
  #        url      = local.funcapp_definitions[def].url
  #        audience = local.funcapp_definitions[def].audience_subnet
  #      }
  #    }
  #  )

  reply_urls = [
    "https://vh-service-web.${local.environment}.platform.hmcts.net/",
    "https://vh-service-web.${local.environment}.platform.hmcts.net/login",
    "https://vh-service-web.${local.environment}.platform.hmcts.net/home",
    "https://vh-service-web.${local.environment}.hearings.reform.hmcts.net/",
    "https://vh-service-web.${local.environment}.hearings.reform.hmcts.net/login",
    "https://vh-service-web.${local.environment}.hearings.reform.hmcts.net/home",
    "https://localhost/home",
    "https://localhost/login",
    "https://localhost/",
    "https://serviceweb_ac/login",
    "https://serviceweb_ac/home",
    "https://serviceweb_ac/",
  ]

  # new apps that need registration can be added as a block below
  app_conf = {
    vh-service-web = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = true
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-service-web.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-service-web.${local.environment}.platform.hmcts.net/",
        "https://vh-service-web.${local.environment}.platform.hmcts.net/login",
        "https://vh-service-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-service-web.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-service-web.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-service-web.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
        "https://serviceweb_ac/login",
        "https://serviceweb_ac/home",
        "https://serviceweb_ac/",
      ]
    }
    vh-video-web = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = true
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-video-web.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-video-web.${local.environment}.platform.hmcts.net/",
        "https://vh-video-web.${local.environment}.platform.hmcts.net/login",
        "https://vh-video-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-video-web.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-video-web.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-video-web.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
        "https://videoweb_ac/login",
        "https://videoweb_ac/home",
        "https://videoweb_ac/",
      ]
    }
    vh-test-web = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = true
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-test-web.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-test-web.${local.environment}.platform.hmcts.net/",
        "https://vh-test-web.${local.environment}.platform.hmcts.net/login",
        "https://vh-test-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-test-web.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-test-web.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-test-web.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
        "https://testweb_ac/login",
        "https://testweb_ac/home",
        "https://testweb_ac/",
      ]
    }
    vh-admin-web = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = true
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-admin-web.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-admin-web.${local.environment}.platform.hmcts.net/",
        "https://vh-admin-web.${local.environment}.platform.hmcts.net/login",
        "https://vh-admin-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-admin-web.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-admin-web.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-admin-web.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
        "https://1905f943.ngrok.io/",
        "https://1905f943.ngrok.io/login",
        "https://1905f943.ngrok.io/home",
        "https://adminweb_ac/login",
        "https://adminweb_ac/home",
        "https://adminweb_ac/",
      ]
    }
    vh-notification-api = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-notification-api.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-notification-api.${local.environment}.platform.hmcts.net/",
        "https://vh-notification-api.${local.environment}.platform.hmcts.net/login",
        "https://vh-notification-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-notification-api.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-notification-api.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-notification-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
      ]
    }
    vh-test-api = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-test-api.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        #"https://vh-test-api.${local.environment}.platform.hmcts.net",
        #"https://vh-test-api.${local.environment}.platform.hmcts.net/login",
        #"https://vh-test-api.${local.environment}.platform.hmcts.net/home",
        #"https://vh-test-api.${local.environment}.hearings.reform.hmcts.net",
        #"https://vh-test-api.${local.environment}.hearings.reform.hmcts.net/login",
        #"https://vh-test-api.${local.environment}.hearings.reform.hmcts.net/home",
        #"https://localhost/home",
        #"https://localhost/login",
        #"https://localhost",
      ]
    }
    vh-video-api = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-video-api.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-video-api.${local.environment}.platform.hmcts.net/",
        "https://vh-video-api.${local.environment}.platform.hmcts.net/login",
        "https://vh-video-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-video-api.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-video-api.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-video-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
      ]
    }
    vh-bookings-api = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-bookings-api.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-bookings-api.${local.environment}.platform.hmcts.net/",
        "https://vh-bookings-api.${local.environment}.platform.hmcts.net/login",
        "https://vh-bookings-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-bookings-api.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-bookings-api.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-bookings-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
      ]
    }
    vh-user-api = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-user-api.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-user-api.${local.environment}.platform.hmcts.net/",
        "https://vh-user-api.${local.environment}.platform.hmcts.net/login",
        "https://vh-user-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-user-api.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-user-api.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-user-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
      ]
    }
    vh-booking-queue = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net/",
        "https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net/login",
        "https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net/home",
        "https://vh-booking-queue-subscriber.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-booking-queue-subscriber.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-booking-queue-subscriber.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
      ]
    }
    vh-scheduler-jobs = {
      available_to_other_tenants = false
      oauth2_allow_implicit_flow = false
      type                       = "webapp/api"
      identifier_uris            = ["https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net"]
      reply_urls = [
        "https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net/",
        "https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net/login",
        "https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net/home",
        "https://vh-scheduler-jobs.${local.environment}.hearings.reform.hmcts.net/",
        "https://vh-scheduler-jobs.${local.environment}.hearings.reform.hmcts.net/login",
        "https://vh-scheduler-jobs.${local.environment}.hearings.reform.hmcts.net/home",
        "https://localhost/home",
        "https://localhost/login",
        "https://localhost/",
      ]
    }
  }

  # API Permissions
  api_permissions = {
    "vh-booking-queue" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
          DirectoryReadWriteAll = {
            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
            type = "Role"
          }
        }
      }
    }
    "vh-scheduler-jobs" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
          DirectoryReadWriteAll = {
            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
            type = "Role"
          }
        }
      }
    }
    "vh-admin-web" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
          DirectoryReadWriteAll = {
            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
            type = "Role"
          }
        }
      }
      "Microsoft Graph" = {
        id = "00000003-0000-0000-c000-000000000000"
        access = {
          GroupReadWriteAll = {
            id   = "62a82d76-70ea-41e2-9197-370581804d09"
            type = "Role"
          }
        }
      }
    }
    "vh-service-web" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
          DirectoryReadWriteAll = {
            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
            type = "Role"
          }
        }
      }
      "Microsoft Graph" = {
        id = "00000003-0000-0000-c000-000000000000"
        access = {
          UserReadAll = {
            id   = "df021288-bdef-4463-88db-98f22de89214"
            type = "Role"
          }
          GroupReadWriteAll = {
            id   = "62a82d76-70ea-41e2-9197-370581804d09"
            type = "Role"
          }
        }
      }
    }
    "vh-video-web" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
        }
      }
    }
    "vh-bookings-api" = {
    }
    "vh-user-api" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
          DirectoryReadWriteAll = {
            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
            type = "Role"
          }
        }
      }
      "Microsoft Graph" = {
        id = "00000003-0000-0000-c000-000000000000"
        access = {
          UserReadWriteAll = {
            id   = "741f803b-c850-494e-b5df-cde7c675a1ca"
            type = "Role"
          }
          GroupReadWriteAll = {
            id   = "62a82d76-70ea-41e2-9197-370581804d09"
            type = "Role"
          }
        }
      }
    }
    "vh-video-api" = {
    }
    "vh-notification-api" = {
    }
    "vh-test-web" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
        }
      }
    }
    "vh-test-api" = {
      "Azure AD Graph" = {
        id = "00000002-0000-0000-c000-000000000000"
        access = {
          UserRead = {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
            type = "Scope"
          }
        }
      }
    }
  }
  #App Roles
  app_roles = {
    # Service Web
    "vh-service-web" = {
      "avh JudicialOfficeHolder" = {
        description = "avh Judicial Office Holder"
        is_enabled  = true
        value       = "avh-JudicialOfficeHolder"
        allowed_member_types = [
          "User",
        ],
        id = "0f8383ee-d710-4ca9-8a02-7c318b81e623"
      }
    }
    # Video Web
    "vh-video-web" = {
      "avh JudicialOfficeHolder" = {
        description = "avh Judicial Office Holder"
        is_enabled  = true
        value       = "avh-JudicialOfficeHolder"
        allowed_member_types = [
          "User",
        ],
        id = "0f8383ee-d710-4ca9-8a02-7c318b81e623"
      }
      "avh Citizen" = {
        description = "This user is able to attend a hearing and perform self tests"
        is_enabled  = true
        value       = "avh-Citizen"
        allowed_member_types = [
          "User",
        ],
        id = "9ab0c0d2-4826-455b-ada1-60788e4ce7d2"
      }
      "avh Video Hearings Officer" = {
        description = "This user can book hearings and support live hearings via the admin portal"
        is_enabled  = true
        value       = "avh-VHO"
        allowed_member_types = [
          "User",
        ],
        id = "b64edf41-6393-4726-8bbf-bcee33455b97"
      }
      "avh Judge" = {
        description = "This user is able to conduct hearings as a judge."
        is_enabled  = true
        value       = "avh-Judge"
        allowed_member_types = [
          "User",
        ],
        id = "df7e44d4-4ba5-4759-9a9d-83cf1815c34e"
      }
      "avh Legal Representative" = {
        description = "This user is able to attend a hearing and perform self tests."
        is_enabled  = true
        value       = "avh-ProfessionalUser"
        allowed_member_types = [
          "User",
        ],
        id = "5e49645a-2af9-4d2d-b9ef-7d4b659e91c7"
      }
    }
    # Test Web
    "vh-test-web" = {
      "avh Video Hearing QA" = {
        description = "avh Video Hearing QA"
        is_enabled  = true
        value       = "avh-VHQA"
        allowed_member_types = [
          "User",
        ],
        id = "bb339a15-17ac-4988-a628-7f1abe4c0165"
      }
    }
    # Admin Web
    "vh-admin-web" = {
      "avh Citizen" = {
        description = "This user is able to attend a hearing and perform self tests"
        is_enabled  = true
        value       = "avh-Citizen"
        allowed_member_types = [
          "User",
        ],
        id = "9ab0c0d2-4826-455b-ada1-60788e4ce7d2"
      }
      "avh Video Hearings Officer" = {
        description = "This user can book hearings and support live hearings via the admin portal"
        is_enabled  = true
        value       = "avh-VHO"
        allowed_member_types = [
          "User",
        ],
        id = "b64edf41-6393-4726-8bbf-bcee33455b97"
      }
      "avh Judge" = {
        description = "This user is able to conduct hearings as a judge."
        is_enabled  = true
        value       = "avh-Judge"
        allowed_member_types = [
          "User",
        ],
        id = "df7e44d4-4ba5-4759-9a9d-83cf1815c34e"
      }
      "avh Legal Representative" = {
        description = "This user is able to attend a hearing and perform self tests."
        is_enabled  = true
        value       = "avh-ProfessionalUser"
        allowed_member_types = [
          "User",
        ],
        id = "5e49645a-2af9-4d2d-b9ef-7d4b659e91c7"
      }
    }
    "vh-notification-api" = {}
    "vh-test-api"         = {}
    "vh-video-api"        = {}
    "vh-bookings-api"     = {}
    "vh-user-api"         = {}
    "vh-booking-queue"    = {}
    "vh-scheduler-jobs"   = {}
  }

  keyvaults = {
    vh-user-api         = "vh-user-api"
    vh-video-api        = "vh-video-api"
    vh-bookings-api     = "vh-bookings-api"
    vh-notification-api = "vh-notification-api"
    vh-test-api         = "vh-test-api"
    vh-admin-web        = "vh-admin-web"
    vh-service-web      = "vh-service-web"
    vh-video-web        = "vh-video-web"
    vh-test-web         = "vh-test-web"
    vh-booking-queue    = "vh-booking-queue"
    vh-scheduler-jobs   = "vh-scheduler-jobs"
  }
}

# Networking Client Details
variable "network_client_id" {
  description = "Client ID of the GlobalNetworkPeering SP"
  type        = string
}
variable "network_client_secret" {
  description = "Client Secret of the GlobalNetworkPeering SP"
  type        = string
  sensitive   = true
}
variable "network_tenant_id" {
  description = "Client Tenant ID of the GlobalNetworkPeering SP"
  type        = string
}

variable "external_passwords" {

  type = map(string)
  default = {
    azuread--temporarypassword  = "temp"
    defaultpassword             = "temp"
    notifyconfiguration--apikey = "temp"
  }
}

## Key Vault Secrets
variable "kv_secrets" {
  description = "Collection of Secrets to import into the Key Vaults"
  type = list(object({
    key_vault_name = string
    secrets = list(object({
      name  = string
      value = string
    }))
  }))
  default = []
  #sensitive = true
}