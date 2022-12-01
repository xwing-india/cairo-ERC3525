from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero, assert_not_equal
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256, uint256_check

from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.introspection.erc165.IERC165 import IERC165
from openzeppelin.security.safemath.library import SafeUint256
from openzeppelin.token.erc721.IERC721Receiver import IERC721Receiver
from openzeppelin.utils.constants.library import (
    IERC721_ID,
    IERC721_METADATA_ID,
    IERC721_RECEIVER_ID,
    IACCOUNT_ID,
)
from extentions import (IERC3525, IERC3525Receiver, IERC3525Metadata)

//Implemented from  https://github.com/ethereum/EIPs/blob/master/assets/eip-3525/contracts/ERC3525.sol


//
// Events
//

@event
func TransferValue(_fromTokenId: Uint256, _toTokenId: Uint256, _value: Uint256) {
}

@event
func ApprovalValue(_tokenId: Uint256, _operator: felt, _value: Uint256) {
}

@event
func SlotChanged(_tokenId: Uint256, _oldSlot: Uint256, _newSlot: Uint256) {
}
//from ERC721
@event
func Transfer(from_: felt, to: felt, tokenId: Uint256) {
}

@event
func Approval(owner: felt, approved: felt, tokenId: Uint256) {
}

@event
func ApprovalForAll(owner: felt, operator: felt, approved: felt) {
}


//
// Storage
//
//ERC3525 new ones
//values
@storage_var
func ERC3525_values(token_id: Uint256) -> (values: Uint256) {
}

// struct ApproveData into cairo
// struct ApproveData {
//         address[] approvals;
//         mapping(address => uint256) allowances;
//     }

@storage_var
func ERC3525_approvals(token_id: Uint256) -> (approvals: felt*) {
}

@storage_var
func ERC3525_approvedValues(token_id: Uint256, approval: felt) -> (allowances: Uint256) {
}

@storage_var
func ERC3525_slots(token_id: Uint256) -> (slot: Uint256) {
}

@storage_var
func ERC3525_slot_uri(slot: Uint256) -> (slot_uri: felt) {
}

//from ERC721
// Token name
@storage_var
func ERC3525_name() -> (name: felt) {
}
// Token symbol
@storage_var
func ERC3525_symbol() -> (symbol: felt) {
}

@storage_var
func ERC3525_decimals() -> (decimals: Uint8) {
}


//mapping from token ID to owner address
@storage_var
func ERC3525_owners(token_id: Uint256) -> (owner: felt) {
}
// Mapping owner address to token count
@storage_var
func ERC3525_balances(account: felt) -> (balance: Uint256) {
}

// @storage_var
// func ERC3525_token_approvals(token_id: Uint256) -> (approved: felt) {
// }

// @storage_var
// func ER3525_operator_approvals(owner: felt, operator: felt) -> (is_approved: felt) {
// }

@storage_var
func ERC3525_token_uri(token_id: Uint256) -> (token_uri: felt) {
}



//not yet

namespace ERC3525 {
    //
    // Constructor
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        name: felt, symbol: felt, decimals: Uint8
    ) {
        ERC3525_name.write(name);
        ERC3525_symbol.write(symbol);
        ERC3525_decimals.write(decimals);

        ERC165.register_interface(IERC3525_ID);
        ERC165.register_interface(IERC3525_METADATA_ID);
        return ();
    }

    //
    // Getters
    //

    //new in ERC3525
    func valueDecimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (decimals: Uint8) {
        return ERC3525_decimals.read();
    }   

    func values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (values: Uint256) {
        with_attr error_message("ERC3525: value query for the zero token_id") {
            assert_not_zero(token_id);
        }
        return ERC3525_values.read(token_id);
    }

    func slotOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (slot: Uint256) {
        with_attr error_message("ERC3525: slot query for the zero token_id") {
            assert_not_zero(token_id);
        }
        return ERC3525_slots.read(token_id);
    }

 
    func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        operator: felt, token_id: Uint256
    ) -> (allowance: Uint256) {
        with_attr error_message("ERC3525: allowance query for the zero token id") {
            assert_not_zero(token_id);
        }
        return ERC3525_allowances.read(operator, token_id);
    }

    
    func slot_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        slot: Uint256
    ) -> (slot_uri: felt) {
        let exists = _exists(slot);
        with_attr error_message("ERC3525_Metadata: URI query for nonexistent slot") {
            assert exists = TRUE;
        }

        // if slotURI is not set, it will return 0
        return ERC3525_slot_uri.read(slot);
    }


    //from ERC721
    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
        return ERC3525_name.read();
    }

    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        symbol: felt
    ) {
        return ERC3525_symbol.read();
    }     

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt
    ) -> (balance: Uint256) {
        with_attr error_message("ERC3525: balance query for the zero address") {
            assert_not_zero(owner);
        }
        return ERC3525_balances.read(owner);
    }

    func owner_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (owner: felt) {
        with_attr error_message("ERC3525: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        let (owner) = ERC721_owners.read(token_id);
        with_attr error_message("ERC3525: owner query for nonexistent token") {
            assert_not_zero(owner);
        }
        return (owner=owner);
    }

    func get_approved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (approved: felt) {
        with_attr error_message("ERC3525: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        let exists = _exists(token_id);
        with_attr error_message("ERC3525: approved query for nonexistent token") {
            assert exists = TRUE;
        }

        return ERC721_token_approvals.read(token_id);
    }

    func is_approved_for_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        owner: felt, operator: felt
    ) -> (is_approved: felt) {
        return ERC3525_operator_approvals.read(owner, operator);
    }

    func token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> (token_uri: felt) {
        let exists = _exists(token_id);
        with_attr error_message("ERC3525_Metadata: URI query for nonexistent token") {
            assert exists = TRUE;
        }

        // if tokenURI is not set, it will return 0
        return ERC3525_token_uri.read(token_id);
    }

    //
    // Externals
    //

    func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        token_id: Uint256, to: felt, value: Uint256
    ) {
        with_attr error_mesage("ERC3525: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }

        // Checks caller is not zero address
        let (caller) = get_caller_address();
        with_attr error_message("ERC3525: cannot approve from the zero address") {
            assert_not_zero(caller);
        }

        // Ensures 'owner' does not equal 'to'
        let (owner) = ERC3525_owners.read(token_id);
        with_attr error_message("ERC3525: approval to current owner") {
            assert_not_equal(owner, to);
        }

        // Checks that either caller equals owner or
        // caller isApprovedForAll on behalf of owner
        if (caller == owner) {
            _approve(token_id, to, value);
            return ();
        } else {
            let (is_approved) = ERC3525_operator_approvals.read(owner, caller);
            with_attr error_message("ERC3525: approve caller is not owner nor approved for all") {
                assert_not_zero(is_approved);
            }
            _approve(token_id, to, value);
            return ();
        }
    }

    
    func transfer_from{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
            from_token_id: Uint256, to: felt, value: Uint256
    ) {
        alloc_locals;
        with_attr error_message("ERC721: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        let (caller) = get_caller_address();
        let is_approved = _is_approved_or_owner(caller, token_id);
        with_attr error_message(
                "ERC721: either is not approved or the caller is the zero address") {
            assert_not_zero(caller * is_approved);
        }
        // Note that if either `is_approved` or `caller` equals `0`,
        // then this method should fail.
        // The `caller` address and `is_approved` boolean are both field elements
        // meaning that a*0==0 for all a in the field,
        // therefore a*b==0 implies that at least one of a,b is zero in the field

        _transfer(from_, to, token_id);
        return ();
    }


    func set_approval_for_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        operator: felt, approved: felt
    ) {
        // Ensures caller is neither zero address nor operator
        let (caller) = get_caller_address();
        with_attr error_message("ERC721: either the caller or operator is the zero address") {
            assert_not_zero(caller * operator);
        }
        // note this pattern as we'll frequently use it:
        //   instead of making an `assert_not_zero` call for each address
        //   we can always briefly write `assert_not_zero(a0 * a1 * ... * aN)`.
        //   This is because these addresses are field elements,
        //   meaning that a*0==0 for all a in the field,
        //   and a*b==0 implies that at least one of a,b are zero in the field
        with_attr error_message("ERC721: approve to caller") {
            assert_not_equal(caller, operator);
        }

        // Make sure `approved` is a boolean (0 or 1)
        with_attr error_message("ERC721: approved is not a Cairo boolean") {
            assert approved * (1 - approved) = 0;
        }

        ERC721_operator_approvals.write(owner=caller, operator=operator, value=approved);
        ApprovalForAll.emit(caller, operator, approved);
        return ();
    }

    
    

    //
    // Internals
    //

    func assert_only_token_owner{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        token_id: Uint256
    ) {
        uint256_check(token_id);
        let (caller) = get_caller_address();
        let (owner) = owner_of(token_id);
        // Note `owner_of` checks that the owner is not the zero address
        with_attr error_message("ERC721: caller is not the token owner") {
            assert caller = owner;
        }
        return ();
    }

    func _is_approved_or_owner{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        spender: felt, token_id: Uint256
    ) -> felt {
        alloc_locals;

        let exists = _exists(token_id);
        with_attr error_message("ERC721: token id does not exist") {
            assert exists = TRUE;
        }

        let (owner) = owner_of(token_id);
        if (owner == spender) {
            return TRUE;
        }

        let (approved_addr) = get_approved(token_id);
        if (approved_addr == spender) {
            return TRUE;
        }

        let (is_operator) = is_approved_for_all(owner, spender);
        if (is_operator == TRUE) {
            return TRUE;
        }

        return FALSE;
    }

    func _exists{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256
    ) -> felt {
        let (exists) = ERC721_owners.read(token_id);
        if (exists == FALSE) {
            return FALSE;
        }

        return TRUE;
    }

    func _approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256, to: felt, value: Uint256
    ) {
        ERC3525_approvals.write(token_id, to);
        ERC3525_approvedValues.write(token_id, to, value);
        // let (owner) = owner_of(token_id);
        ApprovalValue.emit(token_id, to, value);
        return ();
    }

    func _transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        _fromTokenId: Uint256, _toTokenId: Uint256, value: Uint256
    ) {
        let exists_fromTokenId = _exists(_fromTokenId);
        with_attr error_message("ERC3525: transfer from nonexistent token") {
            assert exists = TRUE;
        }
        let exists_toTokenId = _exists(_toTokenId);
        with_attr error_message("ERC3525: transfer to nonexistent token") {
            assert exists = TRUE;
        }

        let (fromToken_balance: Uint256) = ERC3525_values.read(_fromTokenId);
        with_attr error_message("ERC3525: transfer amount exceeds balance") {
            let (new_fromToken_balance: Uint256) = SafeUint256.sub_le(fromToken_balance, value);
        }

        let (fromToken_slot: Uint256) = ERC3525_slots.read(_fromTokenId);
        let (toToken_slot: Uint256) = ERC3525_slots.read(_toTokenId);
        //check
        with_attr error_message("ERC3535: transfer to token with different slot") {
            let (new_slot: Uint256) = SafeUint256.sub_le(toToken_slot, fromToken_slot);
        }

        let (from_) = owner_of(_fromTokenId);
        let (to) = owner_of(_toTokenId);

        // Clear approvals
        _approve(token_id, 0 , 0); 

        // Decrease owner balance
        let (owner_bal) = ERC3525_balances.read(from_);
        let (new_balance: Uint256) = SafeUint256.sub_le(owner_bal, value);
        ERC3525_balances.write(from_, new_balance);

        // Increase receiver balance
        let (receiver_bal) = ERC3525_balances.read(to);
        let (new_balance: Uint256) = SafeUint256.add(receiver_bal, value);
        ERC3525_balances.write(to, new_balance);

       
        Transfer.emit( _fromTokenId, _toTokenId, value);
        return ();
    }

    // func _safe_transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    //     from_: felt, to: felt, token_id: Uint256, data_len: felt, data: felt*
    // ) {
    //     _transfer(from_, to, token_id);

    //     let (success) = _check_onERC721Received(from_, to, token_id, data_len, data);
    //     with_attr error_message("ERC721: transfer to non ERC721Receiver implementer") {
    //         assert_not_zero(success);
    //     }
    //     return ();
    // }

    //TBD
    func _mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
        to: felt, token_id: Uint256
    ) {
        with_attr error_message("ERC721: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        with_attr error_message("ERC721: cannot mint to the zero address") {
            assert_not_zero(to);
        }

        // Ensures token_id is unique
        let exists = _exists(token_id);
        with_attr error_message("ERC721: token already minted") {
            assert exists = FALSE;
        }

        let (balance: Uint256) = ERC721_balances.read(to);
        let (new_balance: Uint256) = SafeUint256.add(balance, Uint256(1, 0));
        ERC721_balances.write(to, new_balance);
        ERC721_owners.write(token_id, to);
        Transfer.emit(0, to, token_id);
        return ();
    }

    // func _safe_mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    //     to: felt, token_id: Uint256, data_len: felt, data: felt*
    // ) {
    //     with_attr error_message("ERC721: token_id is not a valid Uint256") {
    //         uint256_check(token_id);
    //     }
    //     _mint(to, token_id);

    //     let (success) = _check_onERC721Received(0, to, token_id, data_len, data);
    //     with_attr error_message("ERC721: transfer to non ERC721Receiver implementer") {
    //         assert_not_zero(success);
    //     }
    //     return ();
    // }


    //TBD
    func _burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(token_id: Uint256) {
        alloc_locals;
        with_attr error_message("ERC721: token_id is not a valid Uint256") {
            uint256_check(token_id);
        }
        let (owner) = owner_of(token_id);

        // Clear approvals
        _approve(0, token_id);

        // Decrease owner balance
        let (balance: Uint256) = ERC721_balances.read(owner);
        let (new_balance: Uint256) = SafeUint256.sub_le(balance, Uint256(1, 0));
        ERC721_balances.write(owner, new_balance);

        // Delete owner
        ERC721_owners.write(token_id, 0);
        TransferValue.emit(from_token_id, to, token_id);
        return ();
    }

    func _set_token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        token_id: Uint256, token_uri: felt
    ) {
        uint256_check(token_id);
        let exists = _exists(token_id);
        with_attr error_message("ERC721_Metadata: set token URI for nonexistent token") {
            assert exists = TRUE;
        }

        ERC721_token_uri.write(token_id, token_uri);
        return ();
    }
}

//
// Private
//

func _check_onERC721Received{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_: felt, to: felt, token_id: Uint256, data_len: felt, data: felt*
) -> (success: felt) {
    let (caller) = get_caller_address();
    let (is_supported) = IERC165.supportsInterface(to, IERC721_RECEIVER_ID);
    if (is_supported == TRUE) {
        let (selector) = IERC721Receiver.onERC721Received(
            to, caller, from_, token_id, data_len, data
        );

        with_attr error_message("ERC721: transfer to non ERC721Receiver implementer") {
            assert selector = IERC721_RECEIVER_ID;
        }
        return (success=TRUE);
    }

    let (is_account) = IERC165.supportsInterface(to, IACCOUNT_ID);
    return (success=is_account);
}

