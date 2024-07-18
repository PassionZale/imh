"use client";

import { User } from "@/app/interfaces";
import { useSearchParams } from "next/navigation";
import { Suspense, useEffect, useState } from "react";
import Map from "./Map";
import Profile from "./Profile";
import Context from "./context";

async function fetchData(userId?: string): Promise<User | undefined> {
  if (!userId) return;

  const basePath =
    process.env.NODE_ENV === "production"
      ? "https://imh.lovchun.com"
      : "http://localhost:3000";

  const res = await fetch(`${basePath}/api/users/${userId}`, {
    cache: "no-store",
  });

  if (!res.ok) {
    return;
  }

  const user = await res.json();

  return user;
}

const Amap = () => {
  const searchParams = useSearchParams();
  const [user, setUser] = useState<User>();

  const userId =
    searchParams.get("userId") || process.env.NEXT_PUBLIC_DEFAULT_WS;

  const initUser = () => {
    fetchData(userId).then((user) => setUser(user));
  };

  useEffect(() => {
    const intervalId = setInterval(async () => {
      const user = await fetchData(userId);

      setUser(user);
    }, 10000);

    return () => clearInterval(intervalId);
  }, [userId]);

  return (
    <Context.Provider value={{ user: user }}>
      <Map onLoaded={initUser} />
      {user && <Profile />}
    </Context.Provider>
  );
};

export default function LazyAmap() {
  return (
    <Suspense fallback="loading...">
      <Amap />
    </Suspense>
  );
}
