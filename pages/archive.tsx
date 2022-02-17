import React from "react";
import Image from "next/image";
import {
  HollowContainer,
  HollowInput,
  HollowInputContainer,
  HollowTableRow,
} from "../components/Hollow";
import { HomeLayout } from "../components/Layouts";
import styled from "styled-components";

function Archive() {
  // <th>Artist</th>
  //         <th>Title</th>
  //         <th>Media Type</th>
  //         <th>Marketplace</th>
  //         <th>Curator</th>
  //         <th>Rating (Coming soon!)</th>
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
            <th>Curator</th>
          </tr>
        </thead>
        {/* TODO big white line */}
        <tbody>
          <ArchiveTableRow>
            <ArchiveTableDataCell>Jansport J</ArchiveTableDataCell>
            <ArchiveTableDataCell>Song</ArchiveTableDataCell>
            <ArchiveTableDataCell>Marketplace</ArchiveTableDataCell>
            <ArchiveTableDataCell>Me</ArchiveTableDataCell>
          </ArchiveTableRow>
          <ArchiveTableRow>
            <ArchiveTableDataCell>Jansport J</ArchiveTableDataCell>
            <ArchiveTableDataCell>Song</ArchiveTableDataCell>
            <ArchiveTableDataCell>Marketplace</ArchiveTableDataCell>
            <ArchiveTableDataCell>Me</ArchiveTableDataCell>
          </ArchiveTableRow>
          <ArchiveTableRow>
            <ArchiveTableDataCell>Jansport J</ArchiveTableDataCell>
            <ArchiveTableDataCell>Song</ArchiveTableDataCell>
            <ArchiveTableDataCell>Marketplace</ArchiveTableDataCell>
            <ArchiveTableDataCell>Me</ArchiveTableDataCell>
          </ArchiveTableRow>
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
