"use client";

import { useRef, useEffect, memo, useContext } from "react";
import Context from "./context";

function Map() {
  const amapRef = useRef<any>(null);
  const mapRef = useRef<any>(null);
  const { user } = useContext(Context);

  useEffect(() => {
    if (typeof window !== "undefined") {
      //@ts-ignore
      window._AMapSecurityConfig = {
        securityJsCode: process.env.NEXT_PUBLIC_AMAP_SECRET,
      };

      import("@amap/amap-jsapi-loader").then((AMapLoader) => {
        AMapLoader.load({
          key: process.env.NEXT_PUBLIC_AMAP_KEY!,
          version: "2.0",
        }).then((AMap) => {
          amapRef.current = AMap;

          // map
          const map = new AMap.Map("container", {
            viewMode: "3D", // 是否为3D地图模式
            zoom: 16, // 初始化地图级别
            resizeEnable: true,
          });

          mapRef.current = map;
        });
      });
    }

    return () => {
      // @ts-ignore
      mapRef.current?.destroy();
    };
  }, []);

  useEffect(() => {
    const AMap = amapRef.current;
    const map = mapRef.current;

    if (user && AMap && map) {
      if (user.longitude && user.latitude) {
        const marker = new AMap.Marker({
          icon: "/images/marker.png",
          title: user.nickname,
          offset: new AMap.Pixel(-10, -32),
          position: [user.longitude, user.latitude],
        });

        map.setCenter([user.longitude, user.longitude]);
        map.add(marker);
      }
    }
  }, [user]);

  return <div id="container" className="w-screen h-screen" />;
}

export default memo(Map);
