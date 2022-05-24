import { useWeb3React } from "@web3-react/core";
import { ContractTransaction, ethers } from "ethers";
import React from "react";
import "react-toastify/dist/ReactToastify.css";
import Layout from "../components/Layouts";
import { useIsCuratorAdmin } from "../hooks/useIsCurator";
import { useCurator } from "../hooks/web3/useCurator";

function Admin() {
  const { account } = useWeb3React();
  const curator = useCurator();

  const [newCuratorWallet, setNewCuratorWallet] = React.useState<string>();
  const [newCuratorAdminWallet, setNewCuratorAdminWallet] =
    React.useState<string>();

  const isGodAdmin = useIsGodAdmin(account);
  const isCuratorAdmin = useIsCuratorAdmin();
  // console.log("isCuratorAdmin: ", isCuratorAdmin);

  // React.useEffect(() => {
  //   if (curator) {
  //     curator.initialize(
  //       "0x1F1fAA78793Ae021a70c500585051BfDedFd5bec",
  //       "0xd248F2a4829D9C1B78eBA6D1e52703dA5599D65f",
  //       "0x7d1f0b6556f19132e545717C6422e8AB004A5B7c"
  //     );
  //   }
  // }, [curator]);

  const [txn, setTxn] = React.useState<ContractTransaction>();

  const addNewCurator = async (wallet: string) => {
    if (!ethers.utils.isAddress(wallet)) {
      alert("Not a valid wallet, check again");
      return;
    }
    const txn = await curator.grantCuratorRole(wallet);
    setTxn(txn);
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
    if (txn) alert(txn);
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
