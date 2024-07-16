"use client";

import { User } from "@/app/interfaces";
import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import Map from "./Map";
import Profile from "./Profile";
import Context from "./context";

async function fetchData(userId?: string): Promise<User | undefined> {
  if (userId) {
    const res = await fetch(`http://localhost:3000/api/users/${userId}`, {
      cache: "no-store",
    });

    if (!res.ok) {
      return;
    }

    const user = await res.json();

    return user;
  }
}

const Amap = () => {
  const searchParams = useSearchParams();
  const [user, setUser] = useState<User>();

  const userId = searchParams.get("userId")!;

  useEffect(() => {
    const intervalId = setInterval(async () => {
      const user = await fetchData(userId);

      setUser(user);
    }, 10000);

    return () => clearInterval(intervalId);
  }, [userId]);

  return (
    <Context.Provider value={{ user: user }}>
      <Map />
      {user && <Profile />}
    </Context.Provider>
  );
};

export default Amap;
