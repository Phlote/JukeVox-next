import { apollo } from "../../pages/apollo";
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

export const LoginLens = () => {
  const { connect, connectors } = useConnect();
  const { address, connector: activeConnector } = useAccount();

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
  };

  return (
    <>
      {connectors.map((connector) => (
        <div
          className="cursor-pointer m-4 text-center text-xl hover:opacity-50 flex items-center"
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
