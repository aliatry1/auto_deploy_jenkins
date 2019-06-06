exports.handler = async (event) => {
    // TODO implement
    const response = {
        statusCode: 200,
        body: JSON.stringify('This was deployed from Github commit'),
    };
    return response;
};
