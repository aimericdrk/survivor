module.exports = {
    apps: [
      {
        name: "soul-connection-api-prod",
        script: "./index.js",
        env_production: {
          NODE_ENV: "production",
          PORT: 3333,
          watch: false,
          autorestart: false,

        },
      },
      {
        name: "soul-connection-api-dev",
        script: "./index.js",
        env_development: {
          NODE_ENV: "development",
          PORT: 3003,
          watch: true,
          autorestart: true,
          watch: ["index.js", "src"],
          ignore_watch: ["node_modules"],
        },
      },
    ],
  };
