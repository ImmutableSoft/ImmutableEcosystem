# ImmutableEcosystem

The Immutable Ecosystem is a development platform and language agnostic Ethereum based application store. This decentralized ecosystem has two main components, the Solidity Smart Contracts and the Distributed Application (Dapp). This repository is for the Smart Contracts only. The generated API documentation to the Smart Contracts is located in the 'docs' directory. The unit tests of the Smart Contracts are located in the 'tests' directory.

## Bug Bounty

A bug bounty is in effect for the Smart Contracts within the Immutable Ecosystem. If any bug (or suspected bug) is identified in the Smart Contract source code, please open a Git pull request (PR) identifying the error or vulnerability.

To receive the maximum payout the PR should fix the problem and include a unit test that demonstrates the problem and the solution (test should fail without the PR, and pass with the PR). Specific payouts to the bug bounty depend on the severity of the bug as well as the general impact of the bug. In general, the theft of ETH, tokens or Entity accounts is considered the highest severity. Bugs in the Solidity compiler, third party contracts (ERC20, ENS, etc.), or Ethereum and/or EVM in general are explicitly not permissible within this bug bounty unless the bug is directly caused by ImmutableSoft's uses of these third party tools. Also, bugs in the Dapp (once available) are not part of this bug bounty (but please report them if you find them ;-)

The procedure to participate in the bug bounty is to first email Sean at ImmutableSoft dot org and identify the general problem. We will notify you if the problem is still open (another has not already identified this issue). If the issue has not already been identified we will notify you and inform others the bug has already been identified while you prepare a formal report/PR, required within 15 days. Please do not forget this first step so you can ensure your effort will be rewarded.

If you do not have time to develop a formal PR, or wish to remain anonymous, you can submit your report through email. Send your submission directly to Sean at ImmutableSoft dot org. Any submission that is acted upon by ImmutableSoft is eligable for a payout. If you wish to decline payment or receive your reward with tokens, please mention this in email.

## Overview

The Immutable Ecosystem is split into four Smart Contracts. The ImmuteToken is the ERC20 token that monetizes the Ecosystem. The ImmutableEntity handles registered orangizations (entities) within the Ecosystem. The ImmutableProduct is responsible for products and releases created by entities registered with the Ecosystem, including managing product release escrows. The ImmutableLicense handles the creation and validation of product activation licenses and the escrow accounts associated with end user purchases.

Below is the inheritance graph of the various Immutable Ecosystem smart contracts.

![image info](./images/InheritanceGraph.svg)

### ImmutableEntity

Registered Entities can be of various types such as Creator, Distributor, or End User. Each Entity is assigned a unique index within the Ecosystem upon creation. This index, as well as the Entity Ethereum wallet address, can be used to identify the Entity.