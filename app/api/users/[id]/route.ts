import { NextResponse, NextRequest } from "next/server";

type Params = {
  id: string;
};

import db from "@/app/database";

export async function GET(_: Request, context: { params: Params }) {
  const id = context.params.id;

  await db.read();

  const users = db.data?.users ?? [];

  const found = users.find((user) => user.id === id);

  return NextResponse.json(found);
}

export async function PATCH(request: NextRequest, context: { params: Params }) {
  await db.read();

  const users = db.data?.users ?? [];

  const foundIndex = users.findIndex(({ id }) => id === context.params.id);

  if (foundIndex === -1) {
    return NextResponse.json({ message: "用户不存在" }, { status: 404 });
  }

  const body = await request.json();

  users[foundIndex] = { ...users[foundIndex], ...body };

  Object.assign(db.data, { users });

  await db.write();

  return NextResponse.json(db.data.users);
}
