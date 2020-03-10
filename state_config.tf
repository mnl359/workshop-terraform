terraform { 
    backend "s3" {
        bucket          = "tfstate-hachiko-app"
        key             = "terraform-catsanddogs/state"
        region          = "us-east-1"
        dynamodb_table  = "terraform-state"
        encrypt         = true
    }
}