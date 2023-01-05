# NOTE (AM): I think all of the config below needs moving to 'inputs-requiered.tf' & integrating with the main application nested map.

#locals {
#  api_permissions = {
#    "vh-booking-queue" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#          DirectoryReadWriteAll = {
#            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#            type = "Role"
#          }
#        }
#      }
#    }
#    "vh-scheduler-jobs" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#          DirectoryReadWriteAll = {
#            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#            type = "Role"
#          }
#        }
#      }
#    }
#    "vh-admin-web" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#          DirectoryReadWriteAll = {
#            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#            type = "Role"
#          }
#        }
#      }
#      "Microsoft Graph" = {
#        id = "00000003-0000-0000-c000-000000000000"
#        access = {
#          GroupReadWriteAll = {
#            id   = "62a82d76-70ea-41e2-9197-370581804d09"
#            type = "Role"
#          }
#        }
#      }
#    }
#    "vh-service-web" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#          DirectoryReadWriteAll = {
#            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#            type = "Role"
#          }
#        }
#      }
#      "Microsoft Graph" = {
#        id = "00000003-0000-0000-c000-000000000000"
#        access = {
#          UserReadAll = {
#            id   = "df021288-bdef-4463-88db-98f22de89214"
#            type = "Role"
#          }
#          GroupReadWriteAll = {
#            id   = "62a82d76-70ea-41e2-9197-370581804d09"
#            type = "Role"
#          }
#        }
#      }
#    }
#    "vh-video-web" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#        }
#      }
#    }
#    "vh-bookings-api" = {
#    }
#    "vh-user-api" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#          DirectoryReadWriteAll = {
#            id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#            type = "Role"
#          }
#        }
#      }
#      "Microsoft Graph" = {
#        id = "00000003-0000-0000-c000-000000000000"
#        access = {
#          UserReadWriteAll = {
#            id   = "741f803b-c850-494e-b5df-cde7c675a1ca"
#            type = "Role"
#          }
#          GroupReadWriteAll = {
#            id   = "62a82d76-70ea-41e2-9197-370581804d09"
#            type = "Role"
#          }
#        }
#      }
#    }
#        #"video-queue-subscriber" = {
#    #  "Azure AD Graph" = {
#    #    id = "00000002-0000-0000-c000-000000000000"
#    #    access = {
#    #      UserRead = {
#    #        id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#    #        type = "Scope"
#    #      }
#    #      DirectoryReadWriteAll = {
#    #        id   = "78c8a3c8-a07e-4b9e-af1b-b5ccab50a175"
#    #        type = "Role"
#    #      }
#    #    }
#    #  }
#    #}
#    "vh-video-api" = {
#    }
#    "vh-notification-api" = {
#    }
#    "vh-test-web" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#        }
#      }
#    }
#    "vh-test-api" = {
#      "Azure AD Graph" = {
#        id = "00000002-0000-0000-c000-000000000000"
#        access = {
#          UserRead = {
#            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
#            type = "Scope"
#          }
#        }
#      }
#    }
#  }
#
#  app_roles = {
#    # Service Web
#    "vh-service-web" = {
#      "avh JudicialOfficeHolder" = {
#          description  = "avh Judicial Office Holder"
#          is_enabled   = true
#          value        = "avh-JudicialOfficeHolder"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#    }
#    # Video Web
#    "vh-video-web" = {
#      "avh JudicialOfficeHolder" = {
#          description  = "avh Judicial Office Holder"
#          is_enabled   = true
#          value        = "avh-JudicialOfficeHolder"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#      "avh Citizen" = {
#          description  = "This user is able to attend a hearing and perform self tests"
#          is_enabled   = true
#          value        = "avh-Citizen"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#      "avh Video Hearings Officer" = {
#          description  = "This user can book hearings and support live hearings via the admin portal"
#          is_enabled   = true
#          value        = "avh-VHO"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#      "avh Judge" = {
#          description  = "This user is able to conduct hearings as a judge."
#          is_enabled   = true
#          value        = "avh-Judge"
#          allowed_member_types = [
#          "User",
#        ]
#      }
#      "avh Legal Representative" = {
#          description  = "This user is able to attend a hearing and perform self tests."
#          is_enabled   = true
#          value        = "avh-ProfessionalUser"
#          allowed_member_types = [
#          "User",
#        ]
#      }
#    }
#    # Test Web
#    "vh-test-web" = {
#      "avh Video Hearing QA" = {
#          description  = "avh Video Hearing QA"
#          is_enabled   = true
#          value        = "avh-VHQA"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#    }
#    # Admin Web
#    "vh-admin-web" = {
#      "avh Citizen" = {
#          description  = "This user is able to attend a hearing and perform self tests"
#          is_enabled   = true
#          value        = "avh-Citizen"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#      "avh Video Hearings Officer" = {
#          description  = "This user can book hearings and support live hearings via the admin portal"
#          is_enabled   = true
#          value        = "avh-VHO"
#          allowed_member_types = [
#          "User",
#        ]
#      } 
#      "avh Judge" = {
#          description  = "This user is able to conduct hearings as a judge."
#          is_enabled   = true
#          value        = "avh-Judge"
#          allowed_member_types = [
#          "User",
#        ]
#      }
#      "avh Legal Representative" = {
#          description  = "This user is able to attend a hearing and perform self tests."
#          is_enabled   = true
#          value        = "avh-ProfessionalUser"
#          allowed_member_types = [
#          "User",
#        ]
#      }
#    }
#      # (AM) Required for each app even if empty - if all application loop elements are integrated into a single nested map, these will no longer be required).
#      "vh-notification-api" = {}
#      "vh-test-api" = {}
#      "vh-video-api"  = {}
#      "vh-bookings-api"  = {}
#      "vh-user-api"  = {}
#      "vh-booking-queue" = {}
#      "vh-scheduler-jobs" = {}
#  }
#}
