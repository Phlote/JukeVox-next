import { apollo } from "../../lib/apollo";
import { gql } from "@apollo/client";
import Image from "next/image";
import { useConnect, useAccount, useSignMessage } from "wagmi";
import { setAuthenticationToken } from "../../lib/state";
import { toast } from "react-toastify";

const GET_CHALLENGE = `
  query($request: ChallengeRequest!) {
    challenge(request: $request) { text }
  }
`;

const generateChallenge = (address: string) => {
  return apollo.query({
    query: gql`
      ${GET_CHALLENGE}
    `,
    variables: {
      request: {
        address,
      },
    },
  });
};

const AUTHENTICATION = `
  mutation($request: SignedAuthChallenge!) { 
    authenticate(request: $request) {
      accessToken
      refreshToken
    }
 }
`;

const authenticate = (address: string, signature: string) => {
  return apollo.mutate({
    mutation: gql(AUTHENTICATION),
    variables: {
      request: {
        address,
        signature,
      },
    },
  });
};

const GET_PROFILES = `
  query($request: ProfileQueryRequest!) {
    profiles(request: $request) {
      items {
        id
        name
        bio
        attributes {
          displayType
          traitType
          key
          value
        }
        followNftAddress
        metadata
        isDefault
        picture {
          ... on NftImage {
            contractAddress
            tokenId
            uri
            verified
          }
          ... on MediaSet {
            original {
              url
              mimeType
            }
          }
          __typename
        }
        handle
        coverPicture {
          ... on NftImage {
            contractAddress
            tokenId
            uri
            verified
          }
          ... on MediaSet {
            original {
              url
              mimeType
            }
          }
          __typename
        }
        ownedBy
        dispatcher {
          address
          canUseRelay
        }
        stats {
          totalFollowers
          totalFollowing
          totalPosts
          totalComments
          totalMirrors
          totalPublications
          totalCollects
        }
        followModule {
          ... on FeeFollowModuleSettings {
            type
            amount {
              asset {
                symbol
                name
                decimals
                address
              }
              value
            }
            recipient
          }
          ... on ProfileFollowModuleSettings {
            type
          }
          ... on RevertFollowModuleSettings {
            type
          }
        }
      }
      pageInfo {
        prev
        next
        totalCount
      }
    }
  }
`;

export interface ProfilesRequest {
  profileIds?: string[];
  ownedBy?: string;
  handles?: string[];
  whoMirroredPublicationId?: string;
}

const getProfilesRequest = (request: ProfilesRequest) => {
  return apollo.query({
    query: gql(GET_PROFILES),
    variables: {
      request,
    },
  });
};

export const LoginLens = (props) => {
  const { connect, connectors } = useConnect();
  const { address, connector: activeConnector } = useAccount();
  const { connectLens, setConnectLens } = props;
  const { profile, setProfile } = props;

  const { signMessageAsync, isLoading: signLoading } = useSignMessage({
    onError(error) {
      console.error(error);
    },
  });

  const handleSign = async (connector) => {
    connect({ connector });

    // in case of multiple profiles, the first one will be selected. Not ideal but okay for MVP. Alternatives are get default profile or show a screen where user can decide which profile to use
    const profileData = (await getProfilesRequest({ ownedBy: address })).data
      .profiles.items[0];
    if (!profileData) {
      toast.error("Lens Profile not found");
    } else {
      setProfile(profileData);
      const challengeResponse = await generateChallenge(address);

      try {
        const signature = await signMessageAsync({
          message: challengeResponse.data.challenge.text,
        });
        const accessTokens = await authenticate(address, signature);
        setAuthenticationToken(accessTokens.data.authenticate.accessToken);
        setConnectLens(true);
      } catch (error) {
        toast.error(error);
      }
    }
  };

  return (
    <>
      {connectors.map((connector) => (
        <div
          className="w-full h-full text-center"
          onClick={() => {
            handleSign(connector);
          }}
        >
          Sign-in with Lens
          <div className="w-4" />
          <Image src="/exit.svg" alt={"disconnect"} height={24} width={24} />
        </div>
      ))}
    </>
  );
};
