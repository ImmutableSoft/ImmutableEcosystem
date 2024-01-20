// Middleware library for WalletConnect version of universal web3
// interface.
// Copyright 2020-2023 ImmutableSoft Inc. All rights reserved.

import Web3 from "web3";
import WalletConnectProvider from "@walletconnect/web3-provider";

const getWalletConnect = async () =>
{
  const provider = new WalletConnectProvider({
    rpc: { 137: "https://polygon-rpc.com/" },
  });

  //  Enable session (triggers QR Code modal)
  await provider.enable();

  const web3 = new Web3(provider);
  return web3;
}

export default getWalletConnect;
