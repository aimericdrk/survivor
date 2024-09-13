const { soulConnection } = require("../database/mongo");
const { formatDate } = require("./date");

exports.userData = async function (User) {
    data = {
        "user": {
            "username": User.username,
            "email": User.email,
            "role": User.role,
            "creationIp": User.creationIp,
            "lastConnection": await formatDate(User.lastConnection),
            "unique_id": User.unique_id
        }
    }
    const soulApiUser = await soulConnection.collection("employee").findOne({ email: User.email });
    if (soulApiUser) {
        data.user.role = soulApiUser.work;
        data.user.employee_id = soulApiUser.employee_id;
        data.soul_employee = {
            "email": soulApiUser.email,
            "name": soulApiUser.name,
            "surname": soulApiUser.surname,
            "birthdate": soulApiUser.birthdate,
            "gender": soulApiUser.gender,
            "work": soulApiUser.work,
            "employee_id": soulApiUser.employee_id,
            "updated_at": await formatDate(soulApiUser.updated_at),
        }
    }
    return data;
}