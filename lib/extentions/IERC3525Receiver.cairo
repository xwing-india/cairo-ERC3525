%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC3525Receiver {
    func onERC3525Received(
        _operator: felt, _fromTokenId: Uint256, _toTokenId: Uint256, _value: Uint256, data_len: felt, data: felt*
    ) -> (selector: felt) {
    }
}