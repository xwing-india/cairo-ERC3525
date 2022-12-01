%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC3525 { 
    func balanceOf(owner: felt) -> (balance: Uint256) {
    }

    func ownerOf(token_id: Uint256) -> (owner: felt) {
    }

    func safeTransferFrom(_from: felt, to: felt, token_id: Uint256, data_len: felt, data: felt*) {
    }

    func transferFrom(_from: felt, to: felt, token_id: Uint256) {
    }

    func approve(approved: felt, token_id: Uint256) {
    }

    func setApprovalForAll(operator: felt, approved: felt) {
    }

    func getApproved(token_id: Uint256) -> (approved: felt) {
    }

    func isApprovedForAll(owner: felt, operator: felt) -> (is_approved: felt) {
    }

    //from ERC721Enumerable 
    // func totalSupply() -> (totalSupply: Uint256) {
    // }

    // func tokenByIndex(index: Uint256) -> (tokenId: Uint256) {
    // }

    // func tokenOfOwnerByIndex(owner: felt, index: Uint256) -> (tokenId: Uint256) {
    }
}