terraform { 
    backend "s3" {
        bucket          = "terraform-workshop-circleci"
        key             = "terraform-circleci-00/state"
        region          = "us-east-1"
        dynamodb_table  = "a-circleci-terraform-state"
        encrypt         = true
    }
}

#terraform { 
#    backend "s3" {
#        bucket          = "tfstate-hachiko-app"
#        key             = "terraform-circleci-00/state"
#        region          = "us-east-1"
#        dynamodb_table  = "terraform-state"
#        encrypt         = true
#    }
#}
