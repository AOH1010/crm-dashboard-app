const appRole = String(process.env.APP_ROLE || "backend").trim().toLowerCase();

if (appRole === "sync-trigger") {
  await import("./run-sync-trigger.mjs");
} else {
  await import("./start-backend.mjs");
}
