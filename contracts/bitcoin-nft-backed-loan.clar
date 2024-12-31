;; Dynamic NFT-Backed Loan Smart Contract
;; Manages loans backed by NFTs that change attributes based on repayment status

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_NFT_NOT_FOUND (err u101))
(define-constant ERR_ALREADY_LISTED (err u102))
(define-constant ERR_NOT_LISTED (err u103))
(define-constant ERR_INSUFFICIENT_VALUE (err u104))
(define-constant ERR_LOAN_NOT_FOUND (err u105))
(define-constant ERR_LOAN_DEFAULTED (err u106))
(define-constant ERR_LOAN_NOT_DUE (err u107))
(define-constant ERR_LOAN_CLOSED (err u108))

;; NFT Definition
(define-non-fungible-token dynamic-nft uint)

;; Data Maps
(define-map token-attributes
    { token-id: uint }
    {
        rarity: uint,
        power-level: uint,
        condition: uint,
        last-updated: uint
    }
)

(define-map loan-details
    { loan-id: uint }
    {
        borrower: principal,
        lender: principal,
        token-id: uint,
        amount: uint,
        interest-rate: uint,
        duration: uint,
        start-block: uint,
        status: (string-utf8 20),
        missed-payments: uint,
        total-repaid: uint
    }
)

(define-map token-loans 
    { token-id: uint }
    { loan-id: uint }
)

(define-map loan-listings
    { token-id: uint }
    {
        owner: principal,
        requested-amount: uint,
        min-duration: uint,
        max-interest: uint
    }
)

;; Variables
(define-data-var next-token-id uint u1)
(define-data-var next-loan-id uint u1)

;; Read-only functions
(define-read-only (get-token-attributes (token-id uint))
    (map-get? token-attributes { token-id: token-id })
)

(define-read-only (get-loan-details (loan-id uint))
    (map-get? loan-details { loan-id: loan-id })
)

(define-read-only (get-token-loan (token-id uint))
    (map-get? token-loans { token-id: token-id })
)

(define-read-only (get-loan-listing (token-id uint))
    (map-get? loan-listings { token-id: token-id })
)
