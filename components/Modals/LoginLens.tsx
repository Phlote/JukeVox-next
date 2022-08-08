import { apollo } from "../../pages/apollo";
import {
  getAuthenticationToken,
  setAuthenticationToken,
} from "../../pages/state";
import { gql } from "@apollo/client";
import Image from "next/image";
import { useConnect, useAccount, useSignMessage } from "wagmi";

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

export const LoginLens = (props) => {
  const { connect, connectors } = useConnect();
  const { address, connector: activeConnector } = useAccount();
  const { connectLens, setConnectLens } = props;

  const { signMessageAsync, isLoading: signLoading } = useSignMessage({
    onError(error) {
      console.error(error);
    },
  });

  const handleSign = async (connector) => {
    connect({ connector });

    const challengeResponse = await generateChallenge(address);

    const signature = await signMessageAsync({
      message: challengeResponse.data.challenge.text,
    });

    const accessTokens = await authenticate(address, signature);

    setAuthenticationToken(accessTokens.data.authenticate.accessToken);
    setConnectLens(true);
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
        </div>
      ))}
    </>
  );
};
