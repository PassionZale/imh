import { join } from "node:path";
import { Low } from "lowdb";
import { JSONFile } from "lowdb/node";
import { Tables } from "@/app/interfaces";

const file = join(process.cwd(), "/app/database/db.json");

const defaultData: Tables = {
  users: [
    {
      id: process.env.WS_PRIVATE_KEY_1,
      nickname: "Lei Zhang",
      avatar: "//www.lovchun.com/images/avatar.jpg",
    },
  ],
};

const adapter = new JSONFile<Tables>(file);
const db = new Low(adapter, defaultData);

export default db;
