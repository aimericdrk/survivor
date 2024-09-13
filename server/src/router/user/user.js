const UserModel = require("../../database/models/users");
const SessionModel = require("../../database/models/session");
const api_formatter = require("../../middleware/api-formatter.js");
const { soulConnection } = require("../../database/mongo");
const { formatDate } = require("../../utils/date.js");
const { userData } = require("../../utils/user-data.js");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");

var hour = 3600000;
var day = hour * 24;
var month = day * 30;

exports.register = async (req, res) => {
    var tmpUserRegister = null;
    try {
        const register_data = {
            "email": req.body.email,
            "password": req.body.password,
            "username": req.body.username,
            "ip": req.headers["x-forwarded-for"] || req.connection.remoteAddress,
        };
        if (await check_json_data(register_data)) return api_formatter(req, res, 400, "missing_informations", "some of the information were not provided", null, null, null);
        if (await UserModel.emailExists(register_data.email)) return api_formatter(req, res, 400, "email_already_exist", "an account with the provided email already exist", null, null, null);
        if (await UserModel.usernameExists(register_data.username)) return api_formatter(req, res, 400, "username_already_exist", "an account with the provided username already exist", null, null, null);

        await new UserModel({
            email: register_data.email,
            username: register_data.username,
            password: register_data.password,
            creationIp: register_data.ip
        }).save().then(async function (userRegistered) {
            tmpUserRegister = userRegistered;
            await new SessionModel({
                unique_session_id: crypto.randomUUID(),
                signed_id: crypto.randomUUID(),
                user_signed_id: userRegistered.unique_id,
                connexionIp: register_data.ip,
                expire: Date.now() + month,
            }).save().then(async function (sessionRegistered) {
                await userRegistered.updateOne({
                    $addToSet: {
                        link_session_id: sessionRegistered.signed_id
                    }
                });
                return return_signed_cookies(req, res, sessionRegistered, userRegistered);
            });
        });
    } catch (err) {
        console.error(err);
        await delete_user_account(tmpUserRegister);
        return api_formatter(req, res, 500, "errorOccured", "An error occured while trying to register", null, err, null);
    }
};

exports.login = async (req, res) => {
    var tmpSessuion = null;
    try {
        const login_data = {
            "emailOrUsername": req.body.emailOrUsername,
            "password": req.body.password,
            "ip": req.headers["x-forwarded-for"] || req.connection.remoteAddress,
        };
        if (await check_json_data(login_data)) return api_formatter(req, res, 400, "missing_informations", "some of the information were not provided", null, null, null);
        UserModel.findOne({
            $or: [
                {
                    email: login_data.emailOrUsername
                }, {
                    username: login_data.emailOrUsername
                }]
        }).then(async function (userToLogin) {
            if (!userToLogin) return api_formatter(req, res, 401, "user_not_found", "no user found with the provided email or username", null, null, null);
            if (await !userToLogin.comparePassword(login_data.password))
                return api_formatter(req, res, 401, "incorrect_password", "the provided password is incorrect for this account", null, null, null);

            await new SessionModel({
                unique_session_id: crypto.randomUUID(),
                signed_id: crypto.randomUUID(),
                user_signed_id: userToLogin.unique_id,
                connexionIp: login_data.ip,
                expire: Date.now() + month,
            }).save().then(async function (newSession) {
                tmpSessuion = newSession;
                await userToLogin.updateOne({
                    $addToSet: {
                        link_session_id: newSession.signed_id,
                    },
                    lastConnection: Date.now()
                }).catch(async function (err) {
                    return login_error(req, res, err, tmpSessuion);
                });
                return return_signed_cookies(req, res, newSession, userToLogin);
            }).catch(async function (err) {
                return login_error(req, res, err, tmpSessuion);
            });
        }).catch(async function (err) {
            return login_error(req, res, err, tmpSessuion);
        });
    } catch (err) {
        return login_error(req, res, err, tmpSessuion);
    }
};

async function login_error(req, res, errorMsg, tmpSessuion) {
    console.error(errorMsg);
    await reset_user_session(tmpSessuion, null);
    return error_occured(req, res, errorMsg);
}

exports.profile = async (req, res) => {
    return res.status(200).send({ "status": "success", "username": req.user.username });
};

exports.logout = async (req, res) => {
    try {
        if (req.user && req.user != null && req.user != undefined)
            await reset_user_session(req.session, req.user);
        return api_formatter(req, res, 200, "success", "logout successful", null, null, null);
    } catch (err) {
        console.error(err);
        return api_formatter(req, res, 500, "errorOccured", "An error occured while trying to logout", null, err, null);
    }
};

exports.logouteverywhere = async (req, res) => {
    try {
        if (req.user && req.user != null && req.user != undefined)
            delete_every_user_session(req.user);
        return api_formatter(req, res, 200, "success", "you logged out everywhere successful", null, null, null);
    } catch (err) {
        console.error(err);
        return api_formatter(req, res, 500, "errorOccured", "An error occured while trying to logout everywhere", null, err, null);
    }
};

exports.deleteaccount = async (req, res) => {
    try {
        if (!req.user.comparePassword(req.body.password))
            return api_formatter(req, res, 401, "incorrect_password", "the provided password is incorrect for this account", null, null, null);
        await SessionModel.deleteMany({ user_signed_id: req.user.unique_id });
        await UserModel.deleteOne({ _id: req.user._id });
        return api_formatter(req, res, 200, "success", "account deleted successfully", null, null, null);
    } catch (err) {
        console.error(err);
        return api_formatter(req, res, 500, "errorOccured", "An error occured while trying to delete the account", null, err, null);
    }
};

exports.register_employee = async (req, res) => {
    try {
        const register_employee_data = {
            "email": req.body.email,
            "name": req.body.name,
            "surname": req.body.surname,
            "birth_date": req.body.birth_date,
            "gender": req.body.gender,
            "work": req.body.work,
            updated_at: Date.now(),
        };
        const role = register_employee_data.work == "Coach" ? "coach" : "employee";
        const register_data = {
            "email": register_employee_data.email,
            "password": req.body.password,
            "username": register_employee_data.surname,
            "role": role,
            "ip": req.headers["x-forwarded-for"] || req.connection.remoteAddress,
        };
        if (await check_json_data(register_data)) return api_formatter(req, res, 400, "missing_informations", "some of the information for the user were not provided", null, null, null);
        if (await check_json_data(register_employee_data)) return api_formatter(req, res, 400, "missing_informations", "some of the information for the employee were not provided", null, null, null);
        if (await UserModel.emailExists(register_data.email)) return api_formatter(req, res, 400, "email_already_exist", "an account with the provided email already exist", null, null, null);
        if (await UserModel.usernameExists(register_data.username)) return api_formatter(req, res, 400, "username_already_exist", "an account with the provided username already exist", null, null, null);

        const soul_connection_employee = await soulConnection.collection("employee").findOne({ email: register_employee_data.email })
        if (!soul_connection_employee) {
            const newId = await generate_employee_id();
            register_employee_data.employee_id = `${newId}`;
            register_employee_data.id = Number(newId);
            register_data.employee_id = `${newId}`;
            await soulConnection.collection("employee").insertOne(register_employee_data).then(async function (employeeRegistered) {
                return await create_or_delete_employee(register_data, req, res);
            }).catch(async function (err) {
                console.error(err);
                return error_occured(req, res, err);
            });
        } else {
            return await create_or_delete_employee(register_data, req, res);
        }
    } catch (err) {
        console.error(err);
        return api_formatter(req, res, 500, "errorOccured", "An error occured while trying to register", null, err, null);
    }
};

async function create_or_delete_employee(register_data, req, res) {
    new UserModel(register_data).save().then(async function (userRegistered) {
        return api_formatter(req, res, 200, "success", "successfully registered", await userData(userRegistered), null, null, null);
    }).catch(async function (err) {
        await soulConnection.collection("employee").deleteOne({ email: register_data.email });
        return error_occured(req, res, err);
    })
}

async function generate_employee_id() {
    NbEmployee = await soulConnection.collection("employee").countDocuments();
    return NbEmployee + 2;
}

async function return_signed_cookies(req, res, Session, User) {
    try {
        return api_formatter(
            req,
            res,
            200,
            "success",
            "successfully registered",
            await userData(User),
            null,
            jwt.sign({ session_id: Session.unique_session_id }, process.env.SECRET),
            User.username
        );
    }
    catch (err) {
        console.error(err);
        await reset_user_session(Session, User ? User : null);
        return api_formatter(req,
            res,
            500,
            "errorOccured",
            "An error occured while trying to get the auth token",
            null,
            err,
            null,
            null
        );
    }
}

function error_occured(req, res, errorMsg) {
    console.error(errorMsg);
    return api_formatter(req, res, 500, "errorOccured", "An error occured while trying to register", null, errorMsg, null, null);
}

async function check_json_data(json_data) {
    return (Object.values(json_data).includes(undefined) || Object.values(json_data).includes(""));
}

async function reset_user_session(Session, User = null) {
    if (User)
        await User.updateOne({
            $pull: {
                link_session_id: Session ? Session.signed_id : null
            }
        }).catch(function (err) {
            console.error(err);
        });
    if (Session)
        return await SessionModel.deleteOne(
            { unique_session_id: Session ? Session.unique_session_id : null }
        ).catch(function (err) {
            console.error(err);
        });
    return null;
}

async function delete_every_user_session(User) {
    try {
        await User.updateOne({
            link_session_id: []
        }).catch(function (err) {
            console.error(err);
        });
        return await SessionModel.deleteMany(
            { user_signed_id: User ? User.unique_id : null });
    } catch (err) {
        console.error(err);
    }
}

async function delete_user_account(User) {
    delete_every_user_session(User);
    return await UserModel.deleteOne({
        _id: User ? User._id : null
    }).catch(function (err) {
        console.error(err);
    });
}
