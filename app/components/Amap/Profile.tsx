"use client";

import { useContext } from "react";
import Context from "./context";
import Image from "next/image";

const LastUpdate = ({ children }: React.PropsWithChildren) => (
  <>
    最近更新于：<span className="text-blue-600">{children}</span>
  </>
);

const Profile = () => {
  const { user } = useContext(Context);

  return (
    <div className="fixed inset-x-0 bottom-0 text-center">
      <div className="bg-white opacity-80 p-[10px]">
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
          {user?.updatedAt ? (
            <LastUpdate>{user.updatedAt}</LastUpdate>
          ) : (
            <span className="text-gray-700">暂无更新</span>
          )}
        </div>
      </div>
    </div>
  );
};

export default Profile;
