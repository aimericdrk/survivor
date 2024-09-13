const test = require('node:test');
const assert = require('node:assert');
require("dotenv").config();

test_session = null;
my_user_id = null;
server_URL = `http://${process.env.SERVER_URL}:${process.env.PORT}`;

test('POST /register', async (t) => {
    console.log("registering in");
    test_body = JSON.stringify({
        "email": process.env.TEST_EMAIL,
        "username": process.env.TEST_USERNAME,
        "password": process.env.TEST_PASSWORD
    });
    const response = await fetch(`${server_URL}/register`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: test_body,
    });
    const responseBody = await response.json();
    if (response.status == 200)
        test_session = responseBody.session;
    else
        console.log(responseBody);
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be Success');
});

test('GET /profile', async (t) => {
    console.log("getting profile to check if the given session is valid");
    const response = await fetch(`${server_URL}/profile`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.status, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.username, process.env.TEST_USERNAME, 'Expected username to be correct');
});

test('GET /logout', async (t) => {
    console.log("logging out");
    const response = await fetch(`${server_URL}/logout`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
});

test('GET /profile', async (t) => {
    console.log("getting profile to verify the log out");
    const response = await fetch(`${server_URL}/profile`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 401, 'Expected status code to be 401');
    assert.strictEqual(responseBody.messageStatus, "invalidSession", 'Expected status to be invalidSession');
    assert.strictEqual(responseBody.message, "It appears that your session is invalid", 'Expected message to be It appears that your session is invalid');
})

test('POST /login', async (t) => {
    console.log("logging in and updating the token");
    test_body = JSON.stringify({
        "emailOrUsername": process.env.TEST_EMAIL,
        "password": process.env.TEST_PASSWORD,
    });
    const response = await fetch(`${server_URL}/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: test_body,
    });
    const responseBody = await response.json();
    if (response.status == 200)
        test_session = responseBody.session;
    else
        console.log(responseBody);
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be Success');
});

test('POST /login', async (t) => {
    console.log("logging in a second time to create a second session but don't update the token");
    test_body = JSON.stringify({
        "emailOrUsername": process.env.TEST_EMAIL,
        "password": process.env.TEST_PASSWORD,
    });
    const response = await fetch(`${server_URL}/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: test_body,
    });
    const responseBody = await response.json();
    if (response.status != 200)
        console.log(responseBody);
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be Success');
});


test('GET /profile', async (t) => {
    console.log("getting profile to check if the session is valid");
    const response = await fetch(`${server_URL}/profile`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.status, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.username, process.env.TEST_USERNAME, 'Expected username to be correct');
});

test('GET /logouteverywhere', async (t) => {
    console.log("deleting every session");
    const response = await fetch(`${server_URL}/logouteverywhere`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
});

test('GET /profile', async (t) => {
    console.log("getting profile to verify the log out");
    const response = await fetch(`${server_URL}/profile`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 401, 'Expected status code to be 401');
    assert.strictEqual(responseBody.messageStatus, "invalidSession", 'Expected status to be invalidSession');
    assert.strictEqual(responseBody.message, "It appears that your session is invalid", 'Expected message to be It appears that your session is invalid');
})

test('POST /login', async (t) => {
    console.log("logging in and updating the token");
    test_body = JSON.stringify({
        "emailOrUsername": process.env.TEST_EMAIL,
        "password": process.env.TEST_PASSWORD,
    });
    const response = await fetch(`${server_URL}/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: test_body,
    });
    const responseBody = await response.json();
    if (response.status == 200)
        test_session = responseBody.session;
    else
        console.log(responseBody);
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be Success');
});

test('GET /soul_connection_api/customer', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/customer`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.length > 0, true, 'Expected data not to be empty');
});

test('GET /soul_connection_api/employee', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/employee`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.length > 0, true, 'Expected data not to be empty');
});

test('GET /soul_connection_api/event', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/event`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.length > 0, true, 'Expected data not to be empty');
});

test('GET /soul_connection_api/tip', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/tip`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.length > 0, true, 'Expected data not to be empty');
});

test('GET /soul_connection_api/customer/1', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/customer/1`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.id, 1, 'Expected data id to be 1');
    assert.strictEqual(responseBody.data.name, "Nathalie", 'Expected name to be Nathalie');
    assert.strictEqual(responseBody.data.email, "mercier348.nathalie@gmail.com", 'Expected email to be mercier348.nathalie@gmail.com');
    assert.strictEqual(responseBody.data.customer_id, "1", 'Expected customer_id to be 1');
});

test('GET /soul_connection_api/employee/1', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/employee/1`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.id, 1, 'Expected data id to be 1');
    assert.strictEqual(responseBody.data.name, "Billy", 'Expected name to be Billy');
    assert.strictEqual(responseBody.data.email, "billy.bob@soul-connection.fr", 'Expected email to be billy.bob@soul-connection.fr');
    assert.strictEqual(responseBody.data.employee_id, "1", 'Expected employee_id to be 1');
});

test('GET /soul_connection_api/event/1', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/event/1`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.id, 1, 'Expected data id to be 1');
    assert.strictEqual(responseBody.data.name, "Cooking Class", 'Expected name to be Cooking Class');
    assert.strictEqual(responseBody.data.event_id, "1", 'Expected event_id to be 1');
});

test('GET /soul_connection_api/tip/1', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/soul_connection_api/tip/1`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.id, 1, 'Expected data id to be 1');
    assert.strictEqual(responseBody.data.title, "How to Choose a Profile Picture for a Dating App", 'Expected title to be How to Choose a Profile Picture for a Dating App');
    assert.strictEqual(responseBody.data.tip_id, "1", 'Expected tip_id to be 1');
});

test('GET /api/users', async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/api/users`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    for (let i = 0; i < responseBody.data.length; i++) {
        if (responseBody.data[i].username == process.env.TEST_USERNAME)
            my_user_id = responseBody.data[i].unique_id;
    }
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.length > 0, true, 'Expected data not to be empty');
});

test(`GET /api/me`, async (t) => {
    console.log("getting all the data from the soul_connection_api");
    const response = await fetch(`${server_URL}/api/me`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
    assert.strictEqual(responseBody.data.user.username, process.env.TEST_USERNAME, 'Expected username to be correct');
    assert.strictEqual(responseBody.data.user.email, process.env.TEST_EMAIL, 'Expected email to be correct');
});

test('DELETE /profile', async (t) => {
    console.log("deleting the account");
    const response = await fetch(`${server_URL}/profile`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
        body: JSON.stringify({
            "password": process.env.TEST_PASSWORD,
        }),
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 200, 'Expected status code to be 200');
    assert.strictEqual(responseBody.messageStatus, "success", 'Expected success to be success');
});

test('GET /profile', async (t) => {
    console.log("getting profile to verify the log out and account deletion");
    const response = await fetch(`${server_URL}/profile`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'session': test_session
        },
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 401, 'Expected status code to be 401');
    assert.strictEqual(responseBody.messageStatus, "invalidSession", 'Expected status to be invalidSession');
    assert.strictEqual(responseBody.message, "It appears that your session is invalid", 'Expected message to be It appears that your session is invalid');
})

test('POST /login', async (t) => {
    console.log("logging in to ensure that the account is deleted");
    test_body = JSON.stringify({
        "emailOrUsername": process.env.TEST_EMAIL,
        "password": process.env.TEST_PASSWORD,
    });
    const response = await fetch(`${server_URL}/login`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: test_body,
    });
    const responseBody = await response.json();
    assert.strictEqual(response.status, 401, 'Expected status code to be 401');
    assert.strictEqual(responseBody.messageStatus, "user_not_found", 'Expected success to be user_not_found');
})

