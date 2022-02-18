import React from "react";
import Image from "next/image";
import {
  HollowInput,
  HollowInputContainer,
  HollowTableRow,
} from "../components/Hollow";
import { HomeLayout } from "../components/Layouts";
import styled from "styled-components";
import { usePhlote } from "../hooks/usePhlote";
import { Curation } from "../components/Forms/CurationSubmissionForm";
import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";

type ArchiveCuration = Curation & { transactionPending?: boolean };

const userCurationsAtom = atom<ArchiveCuration[]>([]);
export const useUserCurations = () => useAtom(userCurationsAtom);

function Archive() {
  const { account } = useWeb3React();
  const phlote = usePhlote();

  const [curations, setCurations] = useUserCurations();

  const getCurations = async () => {
    const submissions = await phlote.getCuratorSubmissions(account);
    setCurations(submissions as unknown as ArchiveCuration[]);
  };

  React.useEffect(() => {
    if (phlote && account) {
      getCurations();
      phlote.on("*", (res) => {
        console.log(res);
        if (res.event === "EditionCreated") {
          getCurations();
        }
      });
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote, account]);

  //   React.useEffect(() => {
  //     if (phlote && account)
  //   }, [phlote, account]);

  return (
    <HomeLayout>
      <table
        style={{ borderSpacing: "0 1rem", borderCollapse: "separate" }}
        className="table-fixed w-full text-center"
      >
        <thead>
          <tr>
            <th>Artist</th>
            <th>Media Type</th>
            <th>Marketplace</th>
          </tr>
        </thead>
        {/* TODO big white line */}
        <tbody>
          {curations?.map((curation) => {
            const { artistName, mediaType, marketplace, transactionPending } =
              curation;
            return (
              <ArchiveTableRow
                style={transactionPending ? { opacity: 0.5 } : undefined}
                key={`${artistName}${mediaType}${marketplace}`}
              >
                <ArchiveTableDataCell>{artistName}</ArchiveTableDataCell>
                <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>
              </ArchiveTableRow>
            );
          })}
        </tbody>
      </table>
    </HomeLayout>
  );
}

const ArchiveTableRow = styled.tr`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  height: 3.5rem;
  align-items: center;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

const ArchiveTableDataCell = styled.td`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  height: 3.5rem;
  align-items: center;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

export default Archive;
