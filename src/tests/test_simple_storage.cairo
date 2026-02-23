use cairo_starknet_learning::simple_storage::{
    SimpleStorage, ISimpleStorageDispatcher, ISimpleStorageDispatcherTrait,
};
use starknet::syscalls::deploy_syscall;
use starknet::SyscallResultTrait;

fn deploy() -> ISimpleStorageDispatcher {
    let (contract_address, _) = deploy_syscall(
        SimpleStorage::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
    )
        .unwrap_syscall();
    ISimpleStorageDispatcher { contract_address }
}

#[test]
fn test_initial_value_is_zero() {
    let contract = deploy();
    assert(contract.get() == 0, 'Initial value should be 0');
}

#[test]
fn test_set_and_get() {
    let contract = deploy();
    contract.set(42);
    assert(contract.get() == 42, 'Stored value should be 42');
}

#[test]
fn test_overwrite_value() {
    let contract = deploy();
    contract.set(10);
    contract.set(99);
    assert(contract.get() == 99, 'Value should be overwritten');
}
