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

variable "databases" {
  type = map(any)
  default = {
    vhbookings = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    vhvideo = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    vhnotification = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    vhtest = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
  }
}

variable "queues" {
  type = map(any)
  default = {
    booking = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
    video = {
      collation         = "SQL_Latin1_General_CP1_CI_AS"
      edition           = "Standard"
      performance_level = "S0"
    }
  }
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
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = true
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-service-web.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 2
      reply_urls_web                 = []
      optional_claims                = []
      reply_urls_spa = [
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
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = true
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-video-web.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 2
      reply_urls_web                 = []
      optional_claims = [
        {
          name                  = "family_name"
          type                  = "access_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "given_name"
          type                  = "access_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "groups"
          type                  = "access_token"
          essential             = true
          additional_properties = ["sam_account_name"]
        },
        {
          name                  = "family_name"
          type                  = "id_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "given_name"
          type                  = "id_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "groups"
          type                  = "id_token"
          essential             = true
          additional_properties = ["sam_account_name"]
        },
        {
          name                  = "groups"
          type                  = "saml2"
          essential             = false
          additional_properties = []
        }
      ]
      reply_urls_spa = concat([
        "https://vh-video-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-video-web.${local.environment}.platform.hmcts.net/logout",
        "https://vh-video-web.${local.environment}.hearings.reform.hmcts.net/logout",
        "https://vh-video-web.${local.environment}.hearings.reform.hmcts.net/home"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
        var.environment == "prod" ? ["https://video.hearings.reform.hmcts.net/home", "https://video.hearings.reform.hmcts.net/logout", "https://video-sds.hearings.reform.hmcts.net/home", "https://video-sds.hearings.reform.hmcts.net/logout"] : [],
        var.environment == "stg" ? ["https://video.staging.hearings.reform.hmcts.net/home", "https://video.staging.hearings.reform.hmcts.net/logout"] : []
      )
    }
    vh-test-web = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = true
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-test-web.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 2
      reply_urls_web                 = []
      optional_claims                = []
      reply_urls_spa = concat([
        "https://vh-test-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-test-web.${local.environment}.platform.hmcts.net/logout",
        "https://vh-test-web.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-test-web.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
        var.environment == "stg" ? ["https://test.staging.hearings.reform.hmcts.net/home", "https://test.staging.hearings.reform.hmcts.net/logout"] : []
      )
    }
    vh-admin-web = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = true
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-admin-web.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 2
      reply_urls_web                 = []
      optional_claims = [
        {
          name                  = "family_name"
          type                  = "access_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "given_name"
          type                  = "access_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "groups"
          type                  = "access_token"
          essential             = true
          additional_properties = ["sam_account_name"]
        },
        {
          name                  = "family_name"
          type                  = "id_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "given_name"
          type                  = "id_token"
          essential             = true
          additional_properties = []
        },
        {
          name                  = "groups"
          type                  = "id_token"
          essential             = true
          additional_properties = ["sam_account_name"]
        },
        {
          name                  = "groups"
          type                  = "saml2"
          essential             = false
          additional_properties = []
        }
      ]
      reply_urls_spa = concat([
        "https://vh-admin-web.${local.environment}.platform.hmcts.net/home",
        "https://vh-admin-web.${local.environment}.platform.hmcts.net/logout",
        "https://vh-admin-web.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-admin-web.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
        var.environment == "prod" ? ["https://admin.hearings.reform.hmcts.net/home", "https://admin.hearings.reform.hmcts.net/logout", "https://admin-sds.hearings.reform.hmcts.net/home", "https://admin-sds.hearings.reform.hmcts.net/logout"] : [],
        var.environment == "stg" ? ["https://admin.staging.hearings.reform.hmcts.net/home", "https://admin.staging.hearings.reform.hmcts.net/logout"] : []
      )
    }
    vh-notification-api = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-notification-api.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = concat([
        "https://vh-notification-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-notification-api.${local.environment}.platform.hmcts.net/logout",
        "https://vh-notification-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-notification-api.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
      )
    }
    vh-test-api = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-test-api.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = [
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
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-video-api.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = concat([
        "https://vh-video-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-video-api.${local.environment}.platform.hmcts.net/logout",
        "https://vh-video-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-video-api.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
      )
    }
    vh-bookings-api = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-bookings-api.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = concat([
        "https://vh-bookings-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-bookings-api.${local.environment}.platform.hmcts.net/logout",
        "https://vh-bookings-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-bookings-api.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : []
      )
    }
    vh-user-api = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-user-api.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = concat([
        "https://vh-user-api.${local.environment}.platform.hmcts.net/home",
        "https://vh-user-api.${local.environment}.platform.hmcts.net/logout",
        "https://vh-user-api.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-user-api.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
      )
    }
    vh-booking-queue = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = concat([
        "https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net/home",
        "https://vh-booking-queue-subscriber.${local.environment}.platform.hmcts.net/logout",
        "https://vh-booking-queue-subscriber.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-booking-queue-subscriber.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
      )
    }
    vh-scheduler-jobs = {
      available_to_other_tenants     = false
      oauth2_allow_implicit_flow     = false
      type                           = "webapp/api"
      identifier_uris                = ["https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net"]
      requested_access_token_version = 1
      reply_urls_spa                 = []
      optional_claims                = []
      reply_urls_web = concat([
        "https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net/home",
        "https://vh-scheduler-jobs.${local.environment}.platform.hmcts.net/logout",
        "https://vh-scheduler-jobs.${local.environment}.hearings.reform.hmcts.net/home",
        "https://vh-scheduler-jobs.${local.environment}.hearings.reform.hmcts.net/logout"],
        var.environment == "dev" ? ["http://localhost/home", "http://localhost/logout"] : [],
      )
    }
  }
  api_scopes = {
    "vh-admin-web" = {
      "feapi" = {
        admin_consent_description  = "Frontend API Authentication"
        admin_consent_display_name = "FE API"
        user_consent_description   = "Frontend API Authentication"
        user_consent_display_name  = "FE API"
        enabled                    = true
        value                      = "feapi"
      }
    }
    "vh-booking-queue"  = {}
    "vh-scheduler-jobs" = {}
    "vh-service-web"    = {}
    "vh-video-web" = {
      "feapi" = {
        admin_consent_description  = "Frontend API Authentication"
        admin_consent_display_name = "FE API"
        user_consent_description   = "Frontend API Authentication"
        user_consent_display_name  = "FE API"
        enabled                    = true
        value                      = "feapi"
      }
    }
    "vh-bookings-api"     = {}
    "vh-user-api"         = {}
    "vh-video-api"        = {}
    "vh-notification-api" = {}
    "vh-test-web"         = {}
    "vh-test-api"         = {}

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
      "Microsoft Graph" = {
        id = "00000003-0000-0000-c000-000000000000"
        access = {
          Profile = {
            id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
            type = "Scope"
          }
          UserRead = {
            id   = "14dad69e-099b-42c9-810b-d002981feec1"
            type = "Scope"
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
      "Microsoft Graph" = {
        id = "00000003-0000-0000-c000-000000000000"
        access = {
          Profile = {
            id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
            type = "Scope"
          }
          UserRead = {
            id   = "14dad69e-099b-42c9-810b-d002981feec1"
            type = "Scope"
          }
          # GroupReadWriteAll = {
          #   id   = "4e46008b-f24c-477d-8fff-7bb4ec7aafe0"
          #   type = "Scope"
          # }
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
          UserReadWrite = {
            id   = "b4e74841-8e56-480b-be8b-910348b18b4c"
            type = "Scope"
          }
          DirectoryReadWriteAll = {
            id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7"
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

  /*   
    allowed_member_types = ["Application", "User"]
    description          = "Admins can perform all task actions"
    display_name         = "Admin"
    enabled              = true
    id                   = "00000000-0000-0000-0000-222222222222"
    value                = "Admin.All"
*/
  #App Roles
  app_roles = {
    # Service Web
    "vh-service-web" = {
      "JudicialOfficeHolder" = {
        description = "Judicial Office Holder"
        is_enabled  = true
        value       = "JudicialOfficeHolder"
        allowed_member_types = [
          "User",
        ],
        id = "510c1477-6a88-4897-9da4-4dd9b156c32a"
      }
    }
    # Video Web
    "vh-video-web" = {
      "JudicialOfficeHolder" = {
        description = "Judicial Office Holder"
        is_enabled  = true
        value       = "JudicialOfficeHolder"
        allowed_member_types = [
          "User",
        ],
        id = "510c1477-6a88-4897-9da4-4dd9b156c32a"
      }
      "Citizen" = {
        description = "This user is able to attend a hearing and perform self tests"
        is_enabled  = true
        value       = "Citizen"
        allowed_member_types = [
          "User",
        ],
        id = "121fa058-1796-4531-a9ee-63be1d4dc630"
      }
      "Video Hearings Officer" = {
        description = "This user can book hearings and support live hearings via the admin portal"
        is_enabled  = true
        value       = "VHO"
        allowed_member_types = [
          "User",
        ],
        id = "9f32ac9e-228c-4919-9f1b-61d8914ccfbe"
      }
      "Judge" = {
        description = "This user is able to conduct hearings as a judge."
        is_enabled  = true
        value       = "Judge"
        allowed_member_types = [
          "User",
        ],
        id = "431f50b2-fb30-4937-9e91-9b9eeb54097f"
      }
      "Staff Member" = {
        description = "This user is able to conduct hearings as a staff member."
        is_enabled  = true
        value       = "StaffMember"
        allowed_member_types = [
          "User",
        ],
        id = "94b44a32-4f2a-4e3e-9332-d9ddd8de8284"
      }
      "Legal Representative" = {
        description = "This user is able to attend a hearing and perform self tests."
        is_enabled  = true
        value       = "ProfessionalUser"
        allowed_member_types = [
          "User",
        ],
        id = "f3340a0e-2ea2-45c6-b19c-d601b8dac13f"
      }
    }
    # Test Web
    "vh-test-web" = {
      "Video Hearing QA" = {
        description = "Video Hearing QA"
        is_enabled  = true
        value       = "VHQA"
        allowed_member_types = [
          "User",
        ],
        id = "48207c0c-5239-482b-8400-6ff9ae02b1f3"
      }
    }
    # Admin Web
    "vh-admin-web" = {
      "Citizen" = {
        description = "This user is able to attend a hearing and perform self tests"
        is_enabled  = true
        value       = "Citizen"
        allowed_member_types = [
          "User",
        ],
        id = "121fa058-1796-4531-a9ee-63be1d4dc630"
      }
      "Video Hearings Officer" = {
        description = "This user can book hearings and support live hearings via the admin portal"
        is_enabled  = true
        value       = "VHO"
        allowed_member_types = [
          "User",
        ],
        id = "9f32ac9e-228c-4919-9f1b-61d8914ccfbe"
      }

      "Judge" = {
        description = "This user is able to conduct hearings as a judge."
        is_enabled  = true
        value       = "Judge"
        allowed_member_types = [
          "User",
        ],
        id = "431f50b2-fb30-4937-9e91-9b9eeb54097f"
      }
      "Legal Representative" = {
        description = "This user is able to attend a hearing and perform self tests."
        is_enabled  = true
        value       = "ProfessionalUser"
        allowed_member_types = [
          "User",
        ],
        id = "f3340a0e-2ea2-45c6-b19c-d601b8dac13f"
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

  app_directory_roles = {
    "vh-notification-api" = []
    "vh-test-api"         = []
    "vh-video-api"        = []
    "vh-bookings-api"     = []
    "vh-user-api"         = ["729827e3-9c14-49f7-bb1b-9608f156bbb8"] # Helpdesk Admins
    "vh-booking-queue"    = []
    "vh-scheduler-jobs"   = []
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


# CVP Client Details
variable "cvp_client_id" {
  description = "Client ID of the CVP SP"
  type        = string
}
variable "cvp_client_secret" {
  description = "Client Secret of the CVP SP"
  type        = string
  sensitive   = true
}
variable "cvp_subscription_id" {
  description = "Client Subscription ID of the CVP SP"
  type        = string
}

variable "signalr_custom_domain_name" {
  description = "Custom Domain Name for SignalR."
  type        = string
}

## Monitoring
variable "emails_kinly" {
  description = "CSV of Kinly Email Addresses"
  type        = string
  default     = ""
}
variable "emails_dev" {
  description = "CSV of Developer Email Addresses"
  type        = string
  default     = ""
}
variable "emails_devops" {
  description = "CSV of DevOps Email Addresses"
  type        = string
  default     = ""
}

