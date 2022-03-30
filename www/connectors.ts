import { InjectedConnector } from "@web3-react/injected-connector";
import { POLYGON_CHAIN_ID, RINKEBY_CHAIN_ID } from "./constants";

export const injected = new InjectedConnector({
  supportedChainIds: [1, 3, RINKEBY_CHAIN_ID, 5, 42, POLYGON_CHAIN_ID],
});
