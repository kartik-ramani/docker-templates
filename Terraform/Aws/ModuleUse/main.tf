terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}


provider "aws" {
  region = var.region
}


module "firstModule" {

#   source = "github.com/kartik-ramani/terraform-modules/DeployerModule"
  source = "../DeployerModule"
  executionType = var.executionType
  securityGroup = var.securityGroup
  ami           = var.ami
  instanceType  = var.instanceType
  isPrivate     = var.isPrivate
  keyName       = var.keyName
  port          = var.port

  gitUrl = var.gitUrl
  folderName = var.folderName

  dockerUserName = var.dockerUserName
  dockerPassword = var.dockerPassword
  dockerImage    = var.dockerImage
}   
