import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { Low } from "lowdb";
import { JSONFile } from "lowdb/node";
import { Tables } from "@/app/interfaces";

const __dirname = dirname(fileURLToPath(import.meta.url));

const file =
  process.env.NODE_ENV === "production"
    ? join("/tmp/db.json")
    : join(__dirname, "db.json");

const defaultData: Tables = {
  users: [
    {
      id: process.env.WS_PRIVATE_KEY_1,
      nickname: "Lei Zhang",
      avatar: "https://www.lovchun.com/images/avatar.jpg",
    },
  ],
};

const adapter = new JSONFile<Tables>(file);
const db = new Low(adapter, defaultData);

export default db;
