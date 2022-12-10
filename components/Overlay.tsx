import React, { useEffect, useState } from 'react';

const newsletterLink = 'https://view.flodesk.com/pages/636bef21e224ff21ae4bf3c3?_gl=1*r0c6et*_ga*MTg2ODIwMDI4Mi4xNjY4NjAyMTMz*_ga_SHJDGKPK06*MTY3MDYyOTU0OS4zNC4xLjE2NzA2Mjk2ODYuMC4wLjA';

const Overlay = () => {
  const [isMaintenance, setIsMaintenance] = useState(()=>{
    let  saved = typeof window === 'undefined' ? true : localStorage.getItem("hasUserClosedMaintenanceOverlay");
    return !saved;
  });
  const [countdown, setCountdown] = useState(5);
  const [canClick, setCanClick] = useState(false);

  useEffect(() => {
    if (isMaintenance) {
      countdown > 0 && setTimeout(() => setCountdown(countdown - 1), 1000);
      if (countdown <= 0) {
        setCanClick(true);
      }
    }
  }, [countdown]);

  const closeOverlay = () => {
    canClick && setIsMaintenance(false);
    typeof window !== "undefined" && localStorage.setItem('hasUserClosedMaintenanceOverlay', "true");
  }

  if (isMaintenance){
    console.log('render');
    return (
      <div className='fixed top-0 left-0 right-0 bottom-0 z-30 backdrop-blur-md flex flex-col space-y-5 justify-center items-center'>
        <button onClick={closeOverlay}
                className={`absolute top-0 right-0 p-5 ${canClick ? '' : 'cursor-not-allowed'}`}>{canClick ? '' : countdown} (X)
        </button>
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
