provider "aws" {
    region = "ap-northeast-1"
}

// resource "aws_iam_policy" "policy" {
//     name   = "PushCloudWatchLogsPolicy"
//     policy = <<EOF
//     {
//         "Version": "2012-10-17",
//         "Statement": [
//             {
//                 "Sid": "1",
//                 "Effect": "Allow",
//                 "Action": [
//                     "logs:CreateLogStream",
//                     "logs:CreateLogGroup",
//                     "logs:PutLogEvents"
//                 ],
//                 "Resource": "*"
//             }
//         ]
//     }
//     EOF
// }

// resource "aws_iam_role" "role" {
//     name               = "PushCloudWatchLogsRole"
//     assume_role_policy = <<EOF
//     {
//         "Version": "2012-10-17",
//         "Statement": [
//             {
//                 "Action": "sts:AssumeRole",
//                 "Principal": {
//                 "Service": "lambda.amazonaws.com"
//                 },
//                 "Effect": "Allow",
//                 "Sid": ""
//             }
//         ]
//     }
//     EOF
// }

//Valid Values for runtime: nodejs6.10 | nodejs8.10 | java8 | python2.7 | python3.6 | python3.7 | dotnetcore1.0 | dotnetcore2.0 | dotnetcore2.1 | go1.x | ruby2.5 
resource "aws_lambda_function" "test"{
    filename        ="${var.filename}"
    function_name   ="${var.func_name}"
    role            ="${var.role_name}"
    vpc_config  {
        subnet_ids = ["subnet-f4b145af"]
        security_group_ids = ["sg-88e8f9ee"]
    }
    handler         ="index.js"
    runtime         ="nodejs8.10"
    environment {
        variables =
        {
            user = "user04"
            aws_account = "DEV"
            aws_account_id = "0123456"
        }
    }
}