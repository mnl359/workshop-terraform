terraform { 
    backend "s3" {
        bucket          = "terraform-workshop-circleci"
        key             = "terraform-circleci-00/state"
        region          = "us-east-1"
        dynamodb_table  = "terraform-circleci-state"
        encrypt         = true
    }
}