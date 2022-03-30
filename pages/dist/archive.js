"use strict";
exports.__esModule = true;
var Layouts_1 = require("../components/Layouts");
var RatingsMeter_1 = require("../components/RatingsMeter");
var SearchBar_1 = require("../components/SearchBar");
var archive_1 = require("../components/Tables/archive");
var Username_1 = require("../components/Username");
var useSearch_1 = require("../hooks/web3/useSearch");
function Archive() {
    var searchTerm = SearchBar_1.useSearchTerm()[0];
    var searchResults = useSearch_1.useSearch(searchTerm).searchResults;
    return (React.createElement(Layouts_1.ArchiveLayout, null,
        React.createElement("div", { className: "flex flex-col" },
            React.createElement("table", { className: "table-fixed w-full text-center mt-8" },
                React.createElement("thead", null,
                    React.createElement("tr", { style: {
                            borderBottom: "1px solid white",
                            paddingBottom: "1rem"
                        } },
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Date" }),
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Artist" }),
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Title" }),
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Media Type", filterKey: "mediaType" }),
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Platform", filterKey: "marketplace" }),
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Curator", filterKey: "curatorWallet" }),
                        React.createElement(archive_1.ArchiveTableHeader, { label: "Co-Signs" }))),
                searchResults.length > 0 && (React.createElement("tbody", null,
                    React.createElement("tr", { className: "h-4" }), searchResults === null || searchResults === void 0 ? void 0 :
                    searchResults.map(function (curation) {
                        var id = curation.id, curatorWallet = curation.curatorWallet, artistName = curation.artistName, mediaTitle = curation.mediaTitle, mediaType = curation.mediaType, mediaURI = curation.mediaURI, marketplace = curation.marketplace, transactionPending = curation.transactionPending, submissionTime = curation.submissionTime;
                        return (React.createElement(React.Fragment, null,
                            React.createElement(archive_1.ArchiveTableRow, { style: transactionPending ? { opacity: 0.5 } : undefined, key: "" + id },
                                React.createElement(archive_1.ArchiveTableDataCell, null,
                                    React.createElement(archive_1.SubmissionDate, { submissionTimestamp: submissionTime })),
                                React.createElement(archive_1.ArchiveTableDataCell, null, artistName),
                                React.createElement(archive_1.ArchiveTableDataCell, null,
                                    React.createElement("a", { rel: "noreferrer", target: "_blank", href: mediaURI, className: "underline" }, mediaTitle)),
                                React.createElement(archive_1.ArchiveTableDataCell, null, mediaType),
                                React.createElement(archive_1.ArchiveTableDataCell, null, marketplace),
                                React.createElement(archive_1.ArchiveTableDataCell, null,
                                    React.createElement(Username_1.Username, { wallet: curatorWallet, linkToProfile: true })),
                                React.createElement(archive_1.ArchiveTableDataCell, null,
                                    React.createElement(RatingsMeter_1.RatingsMeter, { editionId: id, txnPending: transactionPending }))),
                            React.createElement("tr", { className: "h-4" })));
                    })))),
            searchResults.length === 0 && (React.createElement("div", { className: "w-full mt-4 flex-grow flex justify-center items-center", style: { color: "rgba(105, 105, 105, 1)" } },
                React.createElement("p", { className: "text-lg italic" }, "No Search Results"))))));
}
exports["default"] = Archive;
