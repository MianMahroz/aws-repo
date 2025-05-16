exports.handler = async (event) => {
    const request = event.Records[0].cf.request;
    const headers = request.headers;
    
    // Basic authentication credentials (in real scenario, use environment variables or SSM)
    const validUser = 'demo';
    const validPass = 'password123';
    
    // Check for Authorization header
    if (!headers['authorization'] || headers['authorization'].length === 0) {
        return {
            status: '401',
            statusDescription: 'Unauthorized',
            body: 'Unauthorized',
            headers: {
                'www-authenticate': [{ key: 'WWW-Authenticate', value: 'Basic' }]
            }
        };
    }
    
    // Extract and decode credentials
    const authValue = headers['authorization'][0].value;
    const encoded = authValue.split(' ')[1];
    const decoded = Buffer.from(encoded, 'base64').toString('utf-8');
    const [user, pass] = decoded.split(':');
    
    // Validate credentials
    if (user === validUser && pass === validPass) {
        return request;
    }
    
    return {
        status: '403',
        statusDescription: 'Forbidden',
        body: 'Forbidden'
    };
};