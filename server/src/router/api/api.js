const { mainDB, soulConnection } = require("../../database/mongo");
const api_formatter = require("../../middleware/api-formatter.js");
const { formatDate } = require("../../utils/date.js");
const { userData } = require("../../utils/user-data.js");

exports.get_all = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {

        const data = await soulConnection.collection(req.params.COLLECTIONNAME).find({}).toArray();
        if (data[0]["date"]) {
            data.forEach((element) => {
                const oldDate = element["date"].split("-");
                element["date"] = `${oldDate[2]}-${oldDate[1]}-${oldDate[0]}`;
            });
        }
        return api_formatter(req, res, 200, "success", "données la db recup avec succès", data, null, null);
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Erreur lors de la récupération des données", null, error, null);
    }
};

exports.soul_connection_get_all_coach = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {
        const data = await soulConnection.collection("employee").find({ work: "Coach" }).toArray();
        buffer = [];
        index = 0;
        console.log(data);  
        data.forEach((element) => {
            element["coach_id"] = index;
            buffer.push(element);
            index++;
        });
        console.log(buffer);
        return api_formatter(req, res, 200, "success", "successfully received data", buffer, null, null);
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to get data", null, error, null);
    }
};

exports.soul_connection_get_one_coach = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {
        const allCoach = await soulConnection.collection("employee").find({ work: "Coach" }).toArray();
        if (!allCoach || allCoach[req.params.ID] == null) {
            return api_formatter(req, res, 404, "notFound", "data not found", null, null, null);
        }
        return api_formatter(req, res, 200, "success", "successfully received data", allCoach[req.params.ID], null, null);
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to get data", null, error, null);
    }
}

exports.soul_connection_api = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {
        params = req.params.ID;
        formatPng = false;
        if (params.includes(".png")) {
            params = params.split(".png")[0];
            formatPng = true;
        }
        const collectionQuery = { [`${req.params.COLLECTIONNAME}_id`]: params };
        const soulData = await soulConnection.collection(req.params.COLLECTIONNAME).findOne(collectionQuery);
        if (!soulData)
            return api_formatter(req, res, 404, "notFound", "data not found", null, null, null);
        if (req.params.COLLECTIONNAME.includes("image") && formatPng) {
            try {
                if (!soulData)
                    return api_formatter(req, res, 404, "notFound", "picture not found", null, null, null);
                return res.setHeader('Content-Type', 'image/png').send(soulData["image"].buffer);
            } catch (error) {
                console.error(error);
                return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to get data", null, error, null);
            }
        } else {
            if (soulData["date"]) {
                const oldDate = soulData["date"].split("-");
                soulData["date"] = `${oldDate[2]}-${oldDate[1]}-${oldDate[0]}`;
            }
            return api_formatter(req, res, 200, "success", "successfully received data", soulData, null, null);
        }
    } catch (error) {
        console.error(error);
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to get data", null, error, null);
    }

};

exports.internal_api_get_all = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);

    try {
        const data = await mainDB.collection("users").find({}).toArray();
        let buffer = [];
        await data.forEach(async (element) => {
            buffer.push({
                "username": element.username,
                "email": element.email,
                "role": element.role,
                "creationIp": element.creationIp,
                "lastConnection": await formatDate(element.lastConnection),
                "unique_id": element.unique_id
            });
        });
        return api_formatter(req, res, 200, "success", "successfully received data", buffer, null, null);
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to get data", null, error, null);
    }
}

exports.internal_api_get_one = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);

    try {
        params = req.params.ID;
        formatPng = false;
        if (params.includes(".png")) {
            params = params.split(".png")[0];
            formatPng = true;
        }
        console.log(params);
        const data = await mainDB.collection("users").findOne({
            $or: [
                { unique_id: params },
                { username: params },
                { email: params }
            ]
        });
        if (!data)
            return api_formatter(req, res, 404, "notFound", "data not found", null, null, null);

        if (formatPng) {
            if (!data.profilePicture) 
                return api_formatter(req, res, 404, "notFound", "picture not found", null, null, null);
            return res.setHeader('Content-Type', 'image/png').send(data.profilePicture.buffer);
        } else {
        
        let buffer = {
            "username": data.username,
            "email": data.email,
            "role": data.role,
            "creationIp": data.creationIp,
            "lastConnection": await formatDate(data.lastConnection),
            "unique_id": data.unique_id
        };
        return api_formatter(req, res, 200, "success", "successfully received data", buffer, null, null);
    }
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to get data", null, error, null);
    }
}

exports.internal_api_get_me = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    return api_formatter(req, res, 200, "success", "successfully received data", await userData(req.user), null, null);
}

exports.internal_api_assign = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {
        const assign_data = {
            "coachId": Number(req.body.coachId),
            "customerId": JSON.parse(req.body.customerId)
        };

        if (!assign_data.coachId || !assign_data.customerId)
            return api_formatter(req, res, 400, "badRequest", "missing data", null, null, null);

        const coach = await soulConnection.collection("employee").findOne({ id: assign_data.coachId});
        if (!coach)
            return api_formatter(req, res, 404, "notFound", "coach not found", null, null, null);

        if (coach.work.toLowerCase() != "coach")
            return api_formatter(req, res, 400, "badRequest", "the given employee is not a coach", null, null, null);

        if (typeof assign_data.customerId == "object") {
            let status = {"success": [], "notFound": [], "badRequest": []};
            for (let i = 0; i < assign_data.customerId.length; i++) {
                const customer = await soulConnection.collection("customer").findOne({ customer_id: `${assign_data.customerId[i]}`});
                if (!customer) {
                    status["notFound"].push(assign_data.customerId[i]);
                    continue;
                }
                const assignation = await assign_coach_customers(coach, customer);
                if (assignation === true)
                    status["success"].push(assign_data.customerId[i]);
                else {
                    status["badRequest"].push({ "customer_id": assign_data.customerId[i], "error": assignation });
                    console.error(assignation);
                }
            }
            return api_formatter(req, res, 200, "success", "successfully assigned a coach with a customers", status, null, null);
        } else {
            const customer = await soulConnection.collection("customer").findOne({ customer_id: `${assign_data.customerId}` });
            if (!customer)
                return api_formatter(req, res, 404, "notFound", "customer not found", null, null, null);

            
            const assignation = await assign_coach_customers(coach, customer);
            if (assignation === true)
                return api_formatter(req, res, 200, "success", "successfully assigned a coach with a customers", null, null, null);
            else
                return api_formatter(req, res, 400, "badRequest", "error occured when trying to assign a coach with a customers", null, assignation, null);
        }
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to assign a coach with a customers", null, error, null);
    }
}

async function assign_coach_customers(coach, customer) {
    try {
        const coachAssigned = customer.assigned_coach
        const customerAssigned = coach.assigned_customers

        if (!coachAssigned || !coachAssigned.includes(coach.employee_id))
            await soulConnection.collection("customer").updateOne({ customer_id: customer.customer_id }, { $addToSet: { "assigned_coach": coach.employee_id } });

        if (!customerAssigned || !customerAssigned.includes(customer.customer_id)) {
            await soulConnection.collection("employee").updateOne({ employee_id: coach.employee_id }, { $addToSet: { "assigned_customers": customer.customer_id } });
        }
        return true;
    } catch (error) {
        console.error(error);
        return error;
    }
}

exports.internal_api_unassign = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {
        const unassign_data = {
            "coachId": Number(req.body.coachId),
            "customerId": JSON.parse(req.body.customerId)
        };

        if (!unassign_data.coachId || !unassign_data.customerId)
            return api_formatter(req, res, 400, "badRequest", "missing data", null, null, null);

        const coach = await soulConnection.collection("employee").findOne({ id: unassign_data.coachId});
        if (!coach)
            return api_formatter(req, res, 404, "notFound", "coach not found", null, null, null);

        if (coach.work.toLowerCase() != "coach")
            return api_formatter(req, res, 400, "badRequest", "the given employee is not a coach", null, null, null);

        if (typeof unassign_data.customerId == "object") {
            let status = {"success": [], "notFound": [], "badRequest": []};
            for (let i = 0; i < unassign_data.customerId.length; i++) {
                const customer = await soulConnection.collection("customer").findOne({ customer_id: `${unassign_data.customerId[i]}`});
                if (!customer) {
                    status["notFound"].push(unassign_data.customerId[i]);
                    continue;
                }
                const unassignation = await unassign_coach_customers(coach, customer);
                if (unassignation === true)
                    status["success"].push(unassign_data.customerId[i]);
                else {
                    status["badRequest"].push({ "customer_id": unassign_data.customerId[i], "error": unassignation });
                    console.error(unassignation);
                }
            }
            return api_formatter(req, res, 200, "success", "successfully unassigned a coach with a list of customers", status, null, null);
        } else {
            const customer = await soulConnection.collection("customer").findOne({ customer_id: `${unassign_data.customerId}` });
            if (!customer)
                return api_formatter(req, res, 404, "notFound", "customer not found", null, null, null);

            
            const unassignation = await unassign_coach_customers(coach, customer);
            if (unassignation === true)
                return api_formatter(req, res, 200, "success", "successfully unassigned a coach with a customers", null, null, null);
            else
                return api_formatter(req, res, 400, "badRequest", "error occured when trying to unassign a coach with a customers", null, assignation, null);
        }
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to unassign a coach with a customers", null, error, null);
    }
}

exports.internal_api_set_pp = async (req, res) => {
    if (!req.user || req.user == null)
        return api_formatter(req, res, 401, "noSession", "vous n'êtes pas connecté", null, null, null);
    try {
        params = req.params.ID;

        const user = await mainDB.collection("users").findOne({
            $or: [
                { unique_id: params },
                { username: params },
                { email: params }
            ]
        });
        if (!user)
            return api_formatter(req, res, 404, "notFound", "user not found", null, null, null);
        if (!req.file)
            return api_formatter(req, res, 400, "badRequest", "missing data", null, null, null);
        
        await mainDB.collection("users").updateOne({unique_id: user.unique_id}, { $set: { profilePicture: req.file.buffer }});

        return api_formatter(req, res, 200, "success", "successfully updated profile picture", null, null, null);
    } catch (error) {
        return api_formatter(req, res, 500, "errorOccured", "Error occured when trying to update profile picture", null, error, null);
    }
}

async function unassign_coach_customers(coach, customer) {
    try {
        const coachAssigned = customer.assigned_coach
        const customerAssigned = coach.assigned_customers

        if (coachAssigned && coachAssigned.includes(coach.employee_id))
            soulConnection.collection("customer").updateOne({ customer_id: customer.customer_id }, { $pull : { "assigned_coach": coach.employee_id } });

        if (customerAssigned && customerAssigned.includes(customer.customer_id))
            soulConnection.collection("employee").updateOne({ employee_id: coach.employee_id }, { $pull: { "assigned_customers": customer.customer_id } });

        return true;
    } catch (error) {
        console.error(error);
        return error;
    }
}