/**  
    @Description - Default configuration for all types of requirement 
    @Parameters
        keyName - KeyName of Pem file which requires to connect the EC2 Via SSH
        port - Open the Port of EC2 according the Project default is 80
        isPrivate - Either Github or Docker image is Private or Not Default is false
        region - 
        ami - 

**/


variable "executionType" {
  default = 1
}


variable "keyName" {
  default = "mykey"
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

variable "remoteInline" {
  type = list(string)
  default =  [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt-get install docker.io -y && sudo docker run -dp 80:80 docker/getting-started"
    ]
  }

/** 
    @Description - Configuration variable for the Docker Image
    @Parameters 
        dockerImage - Actual Image name uploaded to DockerHub
        userName - 

    @Commands [{
        loginDocker - docker login --username={maryatdocker} --email=mary@docker.com
    }]

**/
variable "dockerImage" {
  default = "docker/getting-started"
}

variable "dockerUserName" {
  default = null
}

variable "dockerPassword" {
  default = null
}

/** 
        @Description - Configuration variable for the Github

**/

variable "gitUrl" {
  default = "https://github.com/docker/getting-started.git"
}

variable "folderName" {
  default = "getting-started"
}

