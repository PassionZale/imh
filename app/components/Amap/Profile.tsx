"use client";

import { useContext } from "react";
import Context from "./context";
import Image from "next/image";

const Profile = () => {
  const { user } = useContext(Context);

  return (
    <div className="fixed inset-x-0 bottom-0 text-center">
      <div className="bg-white p-[20px] p-[40px]">
        <div className="flex justify-center items-center ">
          <Image
            className="rounded-full mr-2"
            src={user?.avatar!}
            width={40}
            height={40}
            alt={user?.nickname!}
          />

          <div>{user?.nickname}</div>
        </div>

        <div className="mt-4">
          {user?.updatedAt ? `最近更新于${user?.updatedAt}` : "暂无更新"}
        </div>
      </div>
    </div>
  );
};

export default Profile;
