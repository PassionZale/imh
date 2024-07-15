"use client";

import { useRef, useEffect } from "react";

function Amap() {
  const mapRef = useRef(null);

  useEffect(() => {
    // https://lbs.amap.com/api/javascript-api-v2/guide/abc/amap-react
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
          // map
          const map = new AMap.Map("container", {
            viewMode: "3D", // 是否为3D地图模式
            zoom: 16, // 初始化地图级别
            resizeEnable: true,
          });

          mapRef.current = map;

          // marker
          const marker = new AMap.Marker({
            icon: "/images/marker.png",
            title: "Lei",
            offset: new AMap.Pixel(-10, -32),
            position: [114.32032, 30.453795],
          });

          map.setCenter([114.32032, 30.453795]);
          map.add(marker);

          // AMap.plugin("AMap.Geolocation", () => {
          //   const geolocation = new AMap.Geolocation({
          //     enableHighAccuracy: true, // 是否使用高精度定位，默认：true
          //     timeout: 10000, // 设置定位超时时间，默认：无穷大
          //     offset: new AMap.Pixel(10, 20, // 定位按钮的停靠位置的偏移量
          //     zoomToAccuracy: true, //  定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
          //     position: "RB", //  定位按钮的排放位置,  RB表示右下
          //   });

          //   geolocation.getCurrentPosition(function (status, result) {
          //     if (status == "complete") {
          //       // marker
          //       const marker = new AMap.Marker({
          //         icon: "/images/marker.png",
          //         title: "Lei",
          //         offset: new AMap.Pixel(-10, -32),
          //         position: result.position,
          //       });

          //       map.setCenter(result.position);
          //       map.add(marker);
          //     } else {
          //       onError(result);
          //     }
          //   });
          // });
        });
      });
    }

    return () => {
      // @ts-ignore
      mapRef.current?.destroy();
    };
  }, []);

  return <div id="container" className="w-screen h-screen" />;
}

export default Amap;
