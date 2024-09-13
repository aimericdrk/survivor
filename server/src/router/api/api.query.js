const api_interactions = require("./api.js");
const get_user_from_session = require("../../middleware/auth.js");
const uploadfile= require("../image-upload.js");

module.exports = function (app) {
    app.get("/soul_connection_api/coach", get_user_from_session, api_interactions.soul_connection_get_all_coach);
    app.get("/soul_connection_api/coach/:ID", get_user_from_session, api_interactions.soul_connection_get_one_coach);
    app.get("/soul_connection_api/:COLLECTIONNAME", get_user_from_session, api_interactions.get_all);
    app.get("/soul_connection_api/:COLLECTIONNAME/:ID", get_user_from_session, api_interactions.soul_connection_api);
    app.get("/api/users", get_user_from_session, api_interactions.internal_api_get_all);
    app.get("/api/users/:ID", get_user_from_session, api_interactions.internal_api_get_one);
    app.post("/api/users/:ID/set_pp",get_user_from_session, uploadfile.single('image'), api_interactions.internal_api_set_pp);
    app.get("/api/me", get_user_from_session, api_interactions.internal_api_get_me);
    app.post("/api/assign", get_user_from_session, api_interactions.internal_api_assign);
    app.post("/api/unassign", get_user_from_session, api_interactions.internal_api_unassign);

};