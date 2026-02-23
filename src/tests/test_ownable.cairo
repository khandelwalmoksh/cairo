use cairo_starknet_learning::ownable::{Ownable, IOwnableDispatcher, IOwnableDispatcherTrait};
use starknet::syscalls::deploy_syscall;
use starknet::{ContractAddress, SyscallResultTrait};
use starknet::testing::set_caller_address;

fn owner() -> ContractAddress {
    'owner'.try_into().unwrap()
}

fn alice() -> ContractAddress {
    'alice'.try_into().unwrap()
}

fn deploy() -> IOwnableDispatcher {
    let mut calldata = array![];
    calldata.append(owner().into());
    let (contract_address, _) = deploy_syscall(
        Ownable::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false,
    )
        .unwrap_syscall();
    IOwnableDispatcher { contract_address }
}

#[test]
fn test_owner_is_set_on_deploy() {
    let contract = deploy();
    assert(contract.owner() == owner(), 'Owner should match');
}

#[test]
fn test_transfer_ownership() {
    let contract = deploy();
    set_caller_address(owner());
    contract.transfer_ownership(alice());
    assert(contract.owner() == alice(), 'New owner should be alice');
}

#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_non_owner_cannot_transfer() {
    let contract = deploy();
    set_caller_address(alice());
    contract.transfer_ownership(alice());
}

#[test]
fn test_renounce_ownership() {
    let contract = deploy();
    set_caller_address(owner());
    contract.renounce_ownership();
    let zero: ContractAddress = 0.try_into().unwrap();
    assert(contract.owner() == zero, 'Owner should be zero');
}
