# Bitcoin NFT-Backed Loan Smart Contract

## Overview
This smart contract facilitates loans backed by dynamic NFTs (Non-Fungible Tokens). The NFTs have attributes that change dynamically based on the repayment status of the loan. This incentivizes borrowers to make timely repayments, as the value of the NFT can improve or degrade depending on loan performance.

The contract supports the following key functionalities:
- Minting NFTs with initial attributes.
- Listing NFTs for loan offers.
- Offering loans backed by NFTs.
- Repayment tracking and attribute adjustment.
- Loan closure, either through repayment or default.

## Features
1. **Dynamic NFT Attributes**
   - Attributes such as `rarity`, `power-level`, and `condition` are dynamically updated based on loan repayment status.

2. **Loan Management**
   - Loans are created by transferring NFTs to the contract and tracking repayment progress.
   - Loan status changes dynamically between `active`, `completed`, or `defaulted`.

3. **NFT Incentivization**
   - Repayment improves the NFT’s attributes.
   - Missed payments degrade the NFT’s attributes, providing a tangible penalty.

4. **Data Transparency**
   - Read-only functions provide visibility into token attributes, loan details, and listings.

---

## Contract Structure

### Constants
- `CONTRACT_OWNER`: The address that deployed the contract.
- `ERR_*`: Standardized error codes for specific failure scenarios.

### NFT Definition
- `dynamic-nft`: Non-fungible token definition, identified by `uint` token IDs.

### Data Maps
- **`token-attributes`**: Stores NFT attributes such as `rarity`, `power-level`, `condition`, and `last-updated` block.
- **`loan-details`**: Stores details of each loan, including borrower, lender, token ID, loan amount, interest rate, duration, and repayment status.
- **`token-loans`**: Links tokens to their respective loans.
- **`loan-listings`**: Stores loan listing information, such as the owner, requested loan amount, minimum duration, and maximum interest rate.

### Variables
- **`next-token-id`**: Tracks the next NFT token ID to be minted.
- **`next-loan-id`**: Tracks the next loan ID to be created.

---

## Functions

### Public Functions

#### **Minting NFTs**
- `mint-nft (recipient principal)`
  - Mints a new NFT with default attributes and assigns it to the specified recipient.
  - Returns the newly minted token ID.

#### **Listing NFTs for Loan**
- `list-nft-for-loan (token-id uint, requested-amount uint, min-duration uint, max-interest uint)`
  - Lists an NFT for loan offers, specifying loan terms.
  - Requires the sender to own the NFT.

#### **Offering Loans**
- `offer-loan (token-id uint, amount uint, interest-rate uint, duration uint)`
  - Offers a loan to the owner of a listed NFT.
  - Transfers STX to the NFT owner and locks the NFT in the contract.
  - Creates a loan record and links it to the NFT.

#### **Closing Loans**
- `close-loan (loan-id uint)`
  - Closes a loan when the duration has elapsed.
  - If the loan is fully repaid, returns the NFT to the borrower.
  - If the loan is not repaid, transfers the NFT to the lender.

### Read-Only Functions

#### **Retrieving NFT Attributes**
- `get-token-attributes (token-id uint)`
  - Fetches the attributes of a specific NFT.

#### **Retrieving Loan Details**
- `get-loan-details (loan-id uint)`
  - Fetches details of a specific loan.

#### **Retrieving Token Loan Mapping**
- `get-token-loan (token-id uint)`
  - Fetches the loan ID associated with a specific token.

#### **Retrieving Loan Listings**
- `get-loan-listing (token-id uint)`
  - Fetches loan listing details for a specific token.

### Private Functions

#### **Payment Calculation**
- `calculate-payment (loan (tuple ...))`
  - Calculates the payment amount per block based on loan details.

#### **NFT Attribute Update**
- `update-nft-attributes (loan-id uint, payment uint, payment-due uint)`
  - Dynamically adjusts the NFT’s attributes based on repayment performance.

---

## Error Codes

- `ERR_NOT_AUTHORIZED (u100)`: Caller is not authorized to perform the action.
- `ERR_NFT_NOT_FOUND (u101)`: Specified NFT does not exist.
- `ERR_ALREADY_LISTED (u102)`: NFT is already listed for loan.
- `ERR_NOT_LISTED (u103)`: NFT is not listed for loan.
- `ERR_INSUFFICIENT_VALUE (u104)`: Provided value does not meet the requirements.
- `ERR_LOAN_NOT_FOUND (u105)`: Loan does not exist.
- `ERR_LOAN_DEFAULTED (u106)`: Loan is in default status.
- `ERR_LOAN_NOT_DUE (u107)`: Loan duration has not yet elapsed.
- `ERR_LOAN_CLOSED (u108)`: Loan is already closed.

---

## Example Workflow

1. **Minting an NFT**
   - The contract owner calls `mint-nft`, specifying a recipient.
   - A new NFT is created with default attributes.

2. **Listing an NFT**
   - The NFT owner calls `list-nft-for-loan`, specifying loan terms.

3. **Offering a Loan**
   - A lender calls `offer-loan` to provide a loan for the listed NFT.
   - The NFT is transferred to the contract, and STX is transferred to the borrower.

4. **Repayment and Attribute Adjustment**
   - Borrowers make payments, dynamically updating the NFT’s attributes.

5. **Closing the Loan**
   - After the loan duration, the lender or borrower calls `close-loan`.
   - If repaid, the NFT is returned to the borrower; otherwise, it is transferred to the lender.

---

## Security Considerations

- **Ownership Verification**: Ensures only authorized parties can perform actions on NFTs or loans.
- **Dynamic Attribute Update**: Proper handling of edge cases ensures attribute integrity.
- **Fund Transfers**: Uses `stx-transfer?` to securely move funds.
- **Default Handling**: Ensures that defaulted loans transfer NFT ownership to the lender.

---

## Future Enhancements

1. Support for partial repayments.
2. Integration with external NFT marketplaces.
3. Enhanced NFT attribute modeling for richer dynamics.
4. Multi-token support for collateralizing loans with multiple NFTs.

