exports.handler = async (event) => {
    // TODO implement
    const response = {
        statusCode: 200,
        body: JSON.stringify('This is the latest with /var/lib/jenkins/workspace/lambda_deploy_test/test.zip!'),
    };
    return response;
};
