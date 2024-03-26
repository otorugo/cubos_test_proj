import http from "http";
import PG from "pg";
import { config } from "dotenv";

config();
const port = Number(process.env.port);
const { user, pass, host, db_port } = process.env;

const client = new PG.Client(`postgres://${user}:${pass}@${host}:${db_port}`);

let successfulConnection = false;

http
  .createServer(async (req, res) => {
    console.log(`Request: ${req.url}`);
    res.setHeader("Access-Control-Allow-Origin", "http://localhost");
    res.setHeader("Access-Control-Allow-Methods", "OPTIONS, GET");
    res.setHeader("Access-Control-Max-Age", 2592000); // 30 days

    if (req.url === "/") {
      client
        .connect()
        .then(() => {
          successfulConnection = true;
        })
        .catch((err) => console.error("Database not connected -", err.stack));

      res.setHeader("Content-Type", "application/json");
      res.writeHead(200);
      res.statusCode = 200;

      let result;

      try {
        result = (await client.query("SELECT * FROM users")).rows[0];
      } catch (error) {
        console.error(error);
      }

      const data = {
        database: successfulConnection,
        userAdmin: result?.role === "admin",
      };

      res.end(JSON.stringify(data));
    } else {
      res.setHeader("Content-Type", "application/json");
      error = { database: false };
      res.writeHead(503);
      res.end(JSON.stringify(error));
    }
  })
  .listen(port, () => {
    console.log(`Server is listening on port ${port}`);
  });
