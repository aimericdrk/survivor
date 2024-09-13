const { mainDB, soulConnection } = require("../mongo");
const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");

const userSchema = new mongoose.Schema({
    unique_id: {
        type: String,
        unique: true,
        trim: true
    },
    link_session_id: {
        type: Array,
    },
    email: {
        type: String,
        unique: [true, "an account already exist on this email!"],
        lowercase: true,
        trim: true,
        required: [true, "email is required"],
        validate: {
            validator: function (v) {
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
            },
            message: "{VALUE} is not a valid email!"
        },
    },
    role: {
        type: String,
        enum: ["normal", "admin", "employee", "coach"],
        default: "normal",
    },
    username: {
        type: String,
        unique: [true, "an account already exist on this username!"],
        maxlength: [100, "username can't be more than 100 characters"],
        required: [true, "username is required"],
    },
    employee_id: {
        type: String,
        default: ""
    },
    //    phonenumber: {
    //        type: String,
    //        required: 'Your phone number is required',
    //    },
    //    adress: {
    //        type: String,
    //        required: 'Your adress is required',
    //    },
    password: {
        type: String,
        required: "Your password is required",
        max: 100
    },
    oldPassword: {
        type: String,
        max: 100,
        default: ""

    },
    //    firstName: {
    //        type: String,
    //        required: 'First Name is required',
    //        max: 100
    //    },
    //    lastName: {
    //        type: String,
    //        required: 'Last Name is required',
    //        max: 100
    //    },
    creationIp: {
        type: String,
    },
    LastModification: {
        type: Date,
        default: Date.now
    },
    LastModificationIp: {
        type: String,
        default: ""
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    lastConnection: {
        type: Date,
        default: Date.now
    },
});

userSchema.pre("save", function (next) {
    const user = this;

    user.unique_id = crypto.randomUUID();
    user.LastModificationIp = user.creationIp;

    const soul_connection_employee = soulConnection.collection("employee").findOne({ email: user.email })
    .then(function (soul_connection_employee) {
            user.employee_id = soul_connection_employee.employee_id;
            user.role = soul_connection_employee.work;
    })

    bcrypt.genSalt(10, async function (err, salt) {
        if (err) return next(err);
        bcrypt.hash(user.password, salt)
            .then(function (hash) {
                user.password = hash;
                return next();
            })
            .catch(function (err) {
                console.error(err);
                return next(err);
            });
    });
});

userSchema.methods.comparePassword = function (password) {
    return bcrypt.compareSync(password, this.password);
};

userSchema.methods.generateJWT = function () {
    return jwt.sign({
        email: this.email,
        username: this.username,
        role: this.role
    }, process.env.JWT_SECRET, { expiresIn: "1h" });
};

userSchema.statics.emailExists = async function (email) {
    try {
        const found = await this.findOne({ email: email });
        return !!found;
    } catch (err) {
        console.error(err);
        return true;
    }
};

userSchema.statics.usernameExists = async function (username) {
    try {
        return !!(await this.findOne({ username: username }));
    } catch (err) {
        console.error(err);
        return true;
    }
};

const User = mainDB.model("User", userSchema);

module.exports = User;