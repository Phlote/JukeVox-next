import React, { useEffect, useState } from 'react';
import Image from "next/image";

const newsletterLink = 'https://view.flodesk.com/pages/636bef21e224ff21ae4bf3c3?_gl=1*r0c6et*_ga*MTg2ODIwMDI4Mi4xNjY4NjAyMTMz*_ga_SHJDGKPK06*MTY3MDYyOTU0OS4zNC4xLjE2NzA2Mjk2ODYuMC4wLjA';
const treeLink = 'https://www.flaticon.com/download/icon/1324667?icon_id=1324667&author=165&team=165&keyword=Christmas+tree&pack=1324660&style=Filled&style_id=5&format=png&color=%23000000&colored=1&size=512%2C256%2C128%2C64%2C32%2C24%2C16&selection=1&premium=&type=standard&token=03AEkXODAmVxSCAccJxsc-fuG4JKShRIQ4FouWwI2RbKMny5nhcQjPmHwDxFhXq2J2PermHjIN7HY2r8AJFKdMzuclpoUT3Pbv30CJFf6Bcvcc7jCgcH8u_SfSDdWjczJa8_1nz9pIRdrldpkdu8-HHaPIU8tX9h6vRi9-lwT7szsyu4dYQe62SZandYGp5PbE8vYSzP7pBtjg5QpqJwD8Xu0hNalYX4d6GGY5XBWivnsuw6Dn6Bfd-y9eUjCdt55elqvz4hlG0ao7KF3ud83d4oiQEC6IrffvcwtFudI-DxqjWcVchVrl0Tbg-mnbnaVNDIKEyjBt3zfUEWeVE6JfhgdVvPoya-9f3DBPSWFS_CSsUjpAdxZKd9h5wB3DgD_FA7_tla2w7JRmI7zjQL2yFHqphcZBQA5oSGDmK0zXwLoJIAfW_DhZ5c9NnH2Qw3Bdnfd6bO_TPMAkHs6yo8b8rxpi6nKU_loC-nOvBXCoWMr1_OzF1YdIXElO6qlEroaliwP1Q8bq79uGugTOKyw3rwbvb_82tRviDNsa4Oew4iQkXMEDRRGtk0eKJgWQR_R7fhATiqUKrSdVE_mHtNectDNDBcMhKyF6qOUYOpHvIqTQG4NK2EM_CfBrS4Ma34To8_AgjTiJClMKI6IX-0AIqgROmROX7I1MBx1kvPkSgWrJY8hjBBcVaNBUlWqCqHg1gS29p-rPCURJgLBvZ-FJaBpTkSKMKM8cz3q3cEn8i6SXO5x_WiyxneNL1PtwvTE3FjVOPPxWPRXHKEmSWL-jJy_PbJDAg8X42WJBZDIyv6vxrU2VW_0CRybgGhwgTt2KzfGtQJBqE4Unro4pXcvEsu02zJUY0Cg-d7mlxt49mbucnmQUR0WqWHPVvqTytLKkb01ReSGH_7d1gYlQTZPXyr5lgkAoYIYGChf3pHPiDwvneD2t2D8gYK9NWpZ5QaJyo8DVXQEwoOgG3RU7ypOEi_BiNVhGc1lw3DoJSEH2GKbt4M0GlwGU6g7ABUzluMwTob7OAZKJugIkzmhdiivf7snscNQSReYYxMDgClQZ1NKTjNKgqrq4mlB1-si_hHfxqcCJYNKuJ3BFdQ9eRz5hS5co1Pt7zU1uX8pJE-wxuRjsSb59GVKumDTGi2O4IwuYyE5ltmX7EOKMt1neRBo4a1Kf_HRfZEJWMT-dRLMgdOzxryj2LUedkHNHv-pteg6kkX8u1BV9qUzQUFiGo6c035NK2V9wP1qnv6R-EO9WEASaICAh1tsvWr-q8wMvb-yx62EPlusRYTDF2hgtrsSNK502ApV2Xgu5mfECNj9HP5WEB9DoTp_g7R-2VwNIBfw2NHmx0XPMeqMjjHqrJyFcLnASbC3P7fMz9A&search=christmas+tree';

const Overlay = () => {
  const [isMaintenance, setIsMaintenance] = useState(true);
  const [countdown, setCountdown] = useState(5);
  const [canClick, setCanClick] = useState(false); // false

  useEffect(() => {
    let saved = typeof window === 'undefined' ? true : localStorage.getItem("hasUserClosedMaintenanceOverlay");
    setIsMaintenance(!saved);
  }, []);

  useEffect(() => {
    if (isMaintenance) {
      countdown > 0 && setTimeout(() => setCountdown(countdown - 1), 1000);
      if (countdown <= 0) {
        setCanClick(true);
      }
    }
  }, [countdown]);

  const closeOverlay = () => {
    if (canClick) {
      setIsMaintenance(false);
      typeof window !== "undefined" && localStorage.setItem('hasUserClosedMaintenanceOverlay', "true");
    }
  }

  if (isMaintenance) {
    console.log('render');
    return (
      <div
        className='fixed top-0 left-0 right-0 bottom-0 z-30 backdrop-blur-md flex flex-col space-y-5 justify-center items-center'>
        <button onClick={closeOverlay}
                className={`absolute top-0 right-0 p-5 ${canClick ? '' : 'cursor-not-allowed'}`}>{canClick ? '' : countdown} (X)
        </button>
        <Image width={150} height={150} alt='christmas tree' src={'/christmas-tree.png'} className='invert'/>
        <h1 className="text-xl sm:text-5xl">
          Closed for the Holidays!
        </h1>
        <p className="text-sm text-center mx-4 sm:text-xl">
          To stay up to date on all things Phlote, <a target='_blank' className='underline' rel="noreferrer"
                                                      href={newsletterLink}>subscribe to our newsletter</a>.
        </p>
      </div>
    );
  } else {
    console.log('dont render');
    return null;
  }
};

export default Overlay;
