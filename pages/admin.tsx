import { useWeb3React } from "@web3-react/core";
import { ContractTransaction, ethers } from "ethers";
import React from "react";
import { useQuery, useQueryClient } from "react-query";
import "react-toastify/dist/ReactToastify.css";
import Layout from "../components/Layouts";
import { useIsCuratorAdmin } from "../hooks/useIsCurator";
import { useCurator } from "../hooks/web3/useCurator";
import { initializeApollo } from "../lib/graphql/apollo";
import {
  GetCuratorsDocument,
  GetCuratorsQuery,
} from "../lib/graphql/generated";

function Admin() {
  const { account } = useWeb3React();
  const curator = useCurator();
  const queryClient = useQueryClient();

  const [newCuratorWallet, setNewCuratorWallet] = React.useState<string>();
  const [newCuratorAdminWallet, setNewCuratorAdminWallet] =
    React.useState<string>();

  const isGodAdmin = useIsGodAdmin(account);
  const isCuratorAdmin = useIsCuratorAdmin();
  const curators = useGetCurators();

  const [txn, setTxn] = React.useState<ContractTransaction>();

  const addNewCurator = async (wallet: string) => {
    if (!ethers.utils.isAddress(wallet)) {
      alert("Not a valid wallet, check again");
      return;
    }
    const txn = await curator.grantCuratorRole(wallet);
    setTxn(txn);
    txn.wait();
    queryClient.invalidateQueries("curators");
  };

  const revokeCuratorRole = async (wallet: string) => {
    if (!ethers.utils.isAddress(wallet)) {
      alert("Not a valid wallet, check again");
      return;
    }
    const txn = await curator.revokeCuratorRole(wallet);
    setTxn(txn);
    txn.wait();
    queryClient.invalidateQueries("curators");
  };

  const addNewCuratorAdmin = async (wallet: string) => {
    if (!ethers.utils.isAddress(wallet)) {
      alert("Not a valid wallet, check again");
      return;
    }
    const curatorAdminRole = await curator.CURATOR_ADMIN();
    const txn = await curator.grantRole(curatorAdminRole, wallet);
    setTxn(txn);
  };

  React.useEffect(() => {
    if (txn) alert(JSON.stringify(txn));
  }, [txn]);

  return (
    <div className="flex flex-col w-full">
      {(isCuratorAdmin || isGodAdmin) && (
        <>
          <h1> Welcome Curator Admin! Grant a wallet the curator role here</h1>
          <input
            className="w-128 text-black"
            onChange={(e) => setNewCuratorWallet(e.target.value)}
          />
          <div className="h-4"> </div>
          <button
            className="w-64 border"
            onClick={() => addNewCurator(newCuratorWallet)}
          >
            Grant Curator Role
          </button>
          <div className="h-16" />
          {curators?.data?.length && (
            <div>
              <h1>Here are the current curators:</h1>
              <ol className="list-disc">
                {curators.data.map((address) => (
                  <li className="my-4 flex" key={`curator-${address}`}>
                    {address}
                    <div className="w-4"></div>
                    <button
                      className="w-64 bg-red-700 border"
                      onClick={() => revokeCuratorRole(address)}
                    >
                      Revoke
                    </button>
                  </li>
                ))}
              </ol>
            </div>
          )}
        </>
      )}

      <div className="h-32" />

      {isGodAdmin && (
        <>
          <h1> Hello god admin! You can add new curator admins here: </h1>
          <input
            className="w-128 text-black"
            onChange={(e) => setNewCuratorAdminWallet(e.target.value)}
          />
          <div className="h-4"> </div>
          <button
            className="w-64 border"
            onClick={() => addNewCuratorAdmin(newCuratorAdminWallet)}
          >
            Grant Curator Admin Role
          </button>
        </>
      )}
    </div>
  );
}

const useIsGodAdmin = (wallet) => {
  const [isGodAdmin, setIsGodAdmin] = React.useState<boolean>();
  const curator = useCurator();

  React.useEffect(() => {
    if (wallet) {
      curator.admin().then((admin) => {
        setIsGodAdmin(admin === wallet);
      });
    }
  }, [wallet, curator]);

  return isGodAdmin;
};

const useGetCurators = () => {
  const client = initializeApollo();
  return useQuery(["curators"], async () => {
    const res = await client.query<GetCuratorsQuery>({
      query: GetCuratorsDocument,
    });

    return res.data.curatorRoles.map(({ id }) => id);
  });
};

Admin.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center flex-grow">
        {page}
      </div>
    </Layout>
  );
};

export default Admin;
