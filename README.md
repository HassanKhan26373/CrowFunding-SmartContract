Here's a polished and professional version of your **README.md** content for the **Crowdfunding Smart Contract**, formatted for direct copy-paste into your project:

---

# Crowdfunding Smart Contract

This Solidity smart contract implements a basic decentralized crowdfunding platform on the Ethereum blockchain. It enables users to launch and support crowdfunding campaigns transparently, with secure fund management and automated withdrawal or refund logic.

---

## 📚 Table of Contents

* [Features](#features)
* [Contract Structure](#contract-structure)
* [Functions](#functions)
* [Events](#events)
* [How to Deploy](#how-to-deploy)
* [How to Interact](#how-to-interact)
* [License](#license)

---

## ✅ Features

* **Create Campaigns**: Anyone can launch a new campaign with a title, description, target amount, and deadline.
* **Contribute to Campaigns**: Users can contribute Ether (ETH) to active campaigns.
* **Withdraw Funds**: Campaign creators can withdraw funds if the target is met and the deadline has passed.
* **Request Refunds**: Contributors can claim refunds if the campaign fails to meet its funding goal.
* **Blockchain Transparency**: All campaign data and transactions are publicly stored on-chain.

---

## 🧱 Contract Structure

The contract uses a `Campaign` struct and several mappings to store and manage campaign data.

```solidity
struct Campaign {
    address creator;
    string title;
    string description;
    uint256 targetAmount;
    uint256 currentAmount;
    uint256 deadline;
    bool completed;
}

mapping(uint256 => Campaign) public campaigns;
mapping(uint256 => mapping(address => uint256)) public contributions;
uint256 public campaignCount;
```

* `campaigns`: Maps `campaignId` to `Campaign` details.
* `contributions`: Nested mapping that tracks each contributor’s amount per campaign.
* `campaignCount`: Counter for the number of campaigns created.

---

## ⚙️ Functions

### `createCampaign(string _title, string _description, uint256 _targetAmount, uint256 _duration)`

Creates a new crowdfunding campaign.

* **Requirements**: `_targetAmount > 0`, `_duration > 0`
* **Emits**: `CampaignCreated`

---

### `contribute(uint256 _campaignId) payable`

Contribute ETH to a specific campaign.

* **Requirements**:

  * Campaign must exist and not be expired.
  * Campaign must not be marked as completed.
  * `msg.value > 0`
* **Emits**: `ContributionReceived`

---

### `withdrawFunds(uint256 _campaignId)`

Allows the campaign creator to withdraw funds after deadline if target is met.

* **Requirements**:

  * Only the campaign creator can call.
  * Deadline must have passed.
  * Target amount must be reached.
  * Campaign must not be already completed.
* **Emits**: `FundsWithdrawn`

---

### `requestRefund(uint256 _campaignId)`

Allows contributors to request refunds if the campaign fails.

* **Requirements**:

  * Campaign must exist.
  * Deadline must have passed.
  * Target not met.
  * Contributor must have contributed.
  * Campaign must not be completed.
* **Emits**: `RefundIssued`

---

## 📢 Events

```solidity
event CampaignCreated(uint256 campaignId, address creator, string title, uint256 targetAmount, uint256 deadline);
event ContributionReceived(uint256 campaignId, address contributor, uint256 amount);
event FundsWithdrawn(uint256 campaignId, address creator, uint256 amount);
event RefundIssued(uint256 campaignId, address contributor, uint256 amount);
```

---

## 🚀 How to Deploy

You can deploy using Remix, Truffle, Hardhat, or other Solidity environments.

### Example (Remix):

1. Visit [Remix IDE](https://remix.ethereum.org)
2. Create a new `.sol` file and paste the smart contract code.
3. Compile the contract (version `^0.8.0`).
4. Go to **"Deploy & Run Transactions"**:

   * Use `Remix VM` or `Injected Web3` (e.g., MetaMask).
   * Click **Deploy** and confirm in your wallet if needed.

---

## 🛠️ How to Interact

After deployment, interact via Remix or frontend app:

* **createCampaign**: Input title, description, target amount (in Wei), and duration (in seconds).
* **contribute**: Input campaignId and send ETH via the `value` field.
* **withdrawFunds**: Call with campaignId after the deadline if target is met (creator only).
* **requestRefund**: Call with campaignId if the campaign failed (contributors only).
* **campaigns**: Query campaign details by ID.
* **contributions**: Check user contribution to a campaign.
* **campaignCount**: See total campaigns created.

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

```solidity
// SPDX-License-Identifier: MIT
```

---

Let me know if you also want the Solidity code formatted for the same README or exported as a `.md` or `.pdf` file.
