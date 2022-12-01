%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC3525Metadata {
    // /**
    //  * @notice Returns the Uniform Resource Identifier (URI) for the current ERC3525 contract.
    //  * @dev This function SHOULD return the URI for this contract in JSON format, starting with
    //  *  header `data:application/json;`.
    //  *  See https://eips.ethereum.org/EIPS/eip-3525 for the JSON schema for contract URI.
    //  * @return The JSON formatted URI of the current ERC3525 contract
    //  */
    func contractURI() -> (tokenURI: felt) {
    }


    func slotURI(_slot: Uint256) -> (tokenURI: felt){
    }

}