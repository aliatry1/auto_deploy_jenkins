exports.handler = async (event) => {
    // TODO implement
    const response = {
        statusCode: 200,
        body: JSON.stringify('Last terraform test'),
    };
    return response;
};

//Steps to prepare the terraform executions 
//1. terraform init
//2. .terraform file's owner must be ec2-user for the permision to install aws provider
//3. A logic to rename the zip file beccause when terraform plan runs. since the zip file's name for lambda deploment is the same, it doesnt recognize the change in the package and will skip the terrafom apply command.
//terraform plan -lock=false
//terraform apply -lock=false -auto-approve
