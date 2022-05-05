export const gaPageview = (url) => {
  (window as any).gtag("config", process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS, {
    page_path: url,
  });
};

// log specific events happening.
export const gaEvent = ({ action, params }) => {
  (window as any).gtag("event", action, params);
};
