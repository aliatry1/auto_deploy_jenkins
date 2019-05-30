/*
Terraform file:
.tf   OR  tf.json

#list  ["foo", "bar", "baz"]
#Maps  { "foo": "bar", "bar": "baz" }

# Condition
    #resource "aws_instance" "web" {
    #subnet = "${var.env == "production" ? var.prod_subnet : var.dev_subnet}"
#}

------------------------------------------
# provisioners
    #let you upload files, run shell scripts, or install and trigger other software like configuration management tools
------------------------------------------
The “<<-EOF” and “EOF” are Terraform’s heredoc syntax, which allows you to
create multiline strings without having to put “\n” all over the place
------------------------------------------
    #Variable files
    // File content =
        // access_key = "foo"
        // secret_key = "bar"
    # Assign   
        # terraform apply -var-file=FILE.tfvars
    #Access Vars 
        #access_key = "${var.access_key}"
        #secret_key = "${var.secret_key}"
------------------------------------------
# Environment Varable
    # $ export AWS_ACCESS_KEY_ID="anaccesskey"     
    # $ export AWS_SECRET_ACCESS_KEY="asecretkey"
    # $ export AWS_DEFAULT_REGION="us-west-2"
    
# Shared Credentials file
    # %USERPROFILE%\.aws\credentials
------------------------------------------
Create a graph from the script(Install Graphviz software -->   dot)
https://www.terraform.io/docs/commands/graph.html
terraform graph | dot -Tpng > graph.png
------------------------------------------
Instalization:
terraform init --> automatically download and install any Provider binary for the providers in use within the configuration.
------------------------------------------
# terraform plan
    # Plan command lets you see what Terraform will do before actually doing it.
    # resources with a plus sign (+) are going to be created, 
    # resources with a minus sign (-) are going to be deleted 
    # resources with a tilde sign (~) are going to be modified. 
    # -/+ means that Terraform will destroy and recreate the resource
    # When the value displayed is <computed>, it means that the value won't be known until the resource is created.
------------------------------------------
# terraform apply
    # After applyijng the script, it will create terraform.tfstate file.
    # This state file is extremely important; it keeps track of the IDs of created resources so that Terraform knows what it is managing.
    # By default, Terraform stores state locally in a file named terraform.tfstate.
    # When working with Terraform in a team, use of a local file makes Terraform usage complicated because each user must make sure they always have the latest state data before running Terraform and make sure that nobody else runs Terraform at the same time.
    # With remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team.
------------------------------------------
# terraform show
    # inspect the current state
------------------------------------------
# terraform destroy
    # Resources can be destroyed using the terraform destroy command, which is similar to terraform apply but it behaves as if all of the resources have been removed from the configuration.
------------------------------------------
*/

provider "aws"  {
    region = "ap-northeast-1"
    // profile  = "DEVROLE"
    # Static Credential
    # access_key = "anaccesskey"  
    # secret_key = "asecretkey" 
}
//------------------------------------------
//Read the VPCs
data "aws_vpcs" "foo" {
    tags = {
        Name = "*"
    }
}
output "foo" {
    value = "${data.aws_vpcs.foo.ids}"
}
//------------------------------------------
//Create an EC2 instance
resource "aws_instance" "example" {
    ami           = "ami-2757f631"
    instance_type = "t2.micro"
}
//Assign an IP to it
//Terraform is able to infer a dependency, and knows it must create the instance first
resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}
//------------------------------------------
//User data inEC2
resource "aws_instance" "web" {
    ami = "ami-0d7ed3ddb85b521a6"
    instance_type= "t2.micro"

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p 8080 &
        EOF
    tags ={
        Name = "Terraform-Instance"
    }
}
//------------------------------------------
//SG for EC2
resource "aws_security_group" "sg" {
    name = "terraform-example-instance"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
//------------------------------------------
// Depends_on

# New resource for the S3 bucket our application will use.
resource "aws_s3_bucket" "example" {
    # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
    # this name must be changed before applying this example to avoid naming
    # conflicts.
    bucket = "terraform-getting-started-guide"
    acl    = "private"
}

# Change the aws_instance we declared earlier to now include "depends_on"
resource "aws_instance" "example" {
    ami           = "ami-2757f631"
    instance_type = "t2.micro"

    # Tells Terraform that this EC2 instance must be created only after the
    # S3 bucket has been created.
    depends_on = ["aws_s3_bucket.example"]
}
//------------------------------------------

//Provisioner
#The local-exec provisioner executes a command locally on the machine running Terraform

#If a resource successfully creates but fails during provisioning, Terraform will error and mark the resource as "tainted". A resource that is tainted has been physically created, but can't be considered safe to use since provisioning failed.
resource "aws_instance" "web" {
    ami           = "ami-b374d5a5"
    instance_type = "t2.micro"

    provisioner "local-exec" {
        command    = "echo ${self.private_ip} > file.txt"
        on_failure = "continue"
    }
}
//------------------------------------------
output "ip" {
    value = "${aws_eip.ip.public_ip}"
}
