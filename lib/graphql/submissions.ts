import { gql } from "@apollo/client";

export const GET_SUBMISSIONS_BY_WALLET = gql`
  query GetSubmissionsByWallet($wallet: String) {
    submissions(where: { submitterWallet: $wallet }) {
      id
      timestamp
      artistName
      mediaTitle
      mediaTypeGET
      mediaURI
      marketplace
      cosigns
      submitterWallet
    }
  }
`;

export const GET_ALL_WALLETS = gql`
  query GetWallets {
    submissions {
      submitterWallet
    }
  }
`;
