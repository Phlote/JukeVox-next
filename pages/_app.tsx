import { Web3ReactProvider } from "@web3-react/core";
import type { AppProps } from "next/app";
import Head from "next/head";
import { NextPage } from "next/types";
import { ReactElement, ReactNode } from "react";
import { QueryClient, QueryClientProvider } from "react-query";
import "tailwindcss/tailwind.css";
import "../styles/globals.css";
import getLibrary from "../utils/getLibrary";

const queryClient = new QueryClient();

type NextPageWithLayout = NextPage & {
  getLayout?: (page: ReactElement) => ReactNode;
};

type AppPropsWithLayout = AppProps & {
  Component: NextPageWithLayout;
};

const NextWeb3App = ({ Component, pageProps }: AppPropsWithLayout) => {
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
        <Web3ReactProvider getLibrary={getLibrary}>
          {getLayout(<Component {...pageProps} />)}
        </Web3ReactProvider>
      </QueryClientProvider>
    </>
  );
};

export default NextWeb3App;
