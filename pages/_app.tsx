import { Web3ReactProvider } from "@web3-react/core";
import type { AppProps } from "next/app";
import { QueryClient, QueryClientProvider } from "react-query";
import getLibrary from "../getLibrary";
import "../styles/globals.css";

const queryClient = new QueryClient();

const NextWeb3App = ({ Component, pageProps }: AppProps) => {
  return (
    <QueryClientProvider client={queryClient}>
      <Web3ReactProvider getLibrary={getLibrary}>
        <Component {...pageProps} />
      </Web3ReactProvider>
    </QueryClientProvider>
  );
};

// NextWeb3App.getInitialProps = async (appContext) => {};

export default NextWeb3App;
