const express = require("express");

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.get("/status", (req, res) => {
  res.status(200).json({
    service: "platform-engineer-assignment",
    environment: process.env.NODE_ENV || "development",
    version: process.env.APP_VERSION || "dev"
  });
});

app.get("/deployments", (req, res) => {
  res.status(200).json({
    deployments: [
      { name: "sample-app", namespace: "app", status: "running" }
    ],
    note: "This endpoint is intentionally simple. Focus on Kubernetes RBAC instead."
  });
});

app.get("/admin", (req, res) => {
  res.status(200).json({
    message: "Placeholder admin endpoint"
  });
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});