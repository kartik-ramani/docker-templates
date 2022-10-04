variable "keyName" {
  default = "mykey"
}

variable "executionType" {
  default = 1
}

variable "port" {
  default = 80
}

variable "isPrivate" {
  default = false
}

variable "ami" {
  default = "ami-08df94af6199f15b6"
}

variable "instanceType" {
  default = "t2.micro"
}

variable "securityGroup" {
    default = "SOME"
}

variable "region" {
  default = "us-west-2"
}

variable "remoteInline" {
  type = list(string)
  default =  [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt-get install docker.io -y && sudo docker run -dp 80:80 docker/getting-started"
    ]
  }

variable "dockerImage" {
  default = "docker/getting-started"
}

variable "dockerUserName" {
  default = null
}

variable "dockerPassword" {
  default = null
}


variable "gitUrl" {
  default = "https://github.com/docker/getting-started.git"
}

variable "folderName" {
  default = "getting-started"
}