import { NextPage } from "next";
import { AppProps } from "next/app";
import Head from "next/head";
import { useRouter } from "next/router";
import React, { ReactElement, ReactNode, useEffect } from "react";
import { MoralisProvider } from "react-moralis";
import { QueryClient, QueryClientProvider } from "react-query";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.min.css";
import ReactTooltip from "react-tooltip";
import "tailwindcss/tailwind.css";
import { gaPageview } from "../lib/ga";
import "../styles/globals.css";
import getLibrary from "../utils/getLibrary";
import Overlay from "../components/Overlay";

const queryClient = new QueryClient();

type NextPageWithLayout = NextPage & {
  getLayout?: (page: ReactElement) => ReactNode;
};

type AppPropsWithLayout = AppProps & {
  Component: NextPageWithLayout;
};

const NextWeb3App = ({ Component, pageProps }: AppPropsWithLayout) => {
  const router = useRouter();

  useEffect(() => {
    const handleRouteChange = (url) => {
      gaPageview(url);
    };
    //When the component is mounted, subscribe to router changes
    //and log those page views
    router.events.on("routeChangeComplete", handleRouteChange);

    // If the component is unmounted, unsubscribe
    // from the event with the `off` method
    return () => {
      router.events.off("routeChangeComplete", handleRouteChange);
    };
  }, [router.events]);

  if (process.env.NEXT_PUBLIC_MAINTENANCE) {
    return <div>Down for maintenance. Try again later!</div>;
  }

  const getLayout = Component.getLayout ?? ((page) => page);

  return (
    <>
      <Head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Phlote Search</title>
        <link rel="icon" href="/favicon.svg" type="image/svg+xml" />
        {/* TODO edit this png to be a square */}
        <link rel="icon" type="image/png" href="/favicon.png" />
        <link rel="icon" href="/favicon.ico" sizes="any" />
      </Head>
      <QueryClientProvider client={queryClient}>
        <MoralisProvider serverUrl={process.env.NEXT_PUBLIC_MORALIS_SERVER_URL} appId={process.env.NEXT_PUBLIC_MORALIS_APP_ID}>
          {getLayout(<Component {...pageProps} />)}
          <ToastContainer
            position="top-right"
            autoClose={5000}
            hideProgressBar={false}
            newestOnTop={false}
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
          />
        </MoralisProvider>
      </QueryClientProvider>
      <ReactTooltip type="dark" effect="solid" place="left" backgroundColor='#000000'/>
    </>
  );
};

export default NextWeb3App;
