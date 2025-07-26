;; Dev Bootcamp Credential NFT Contract
;; Issues a non-transferable NFT to verified graduates

(define-non-fungible-token bootcamp-nft uint)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-issued (err u101))

;; Track which user received the NFT
(define-map credentials-issued principal bool)

;; Function 1: Issue credential (only by contract owner)
(define-public (issue-credential (recipient principal) (token-id uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-none (nft-get-owner? bootcamp-nft token-id)) err-already-issued)
    (map-set credentials-issued recipient true)
    (try! (nft-mint? bootcamp-nft token-id recipient))
    (ok true)))

;; Function 2: Return credential metadata URI
(define-read-only (get-credential-uri (token-id uint))
  (ok (some "https://bootcamp.xyz/credentials/metadata.json")))


