use cairo_starknet_learning::hello_starknet::{
    HelloStarknet, IHelloStarknetDispatcher, IHelloStarknetDispatcherTrait,
};
use starknet::syscalls::deploy_syscall;
use starknet::SyscallResultTrait;

fn deploy() -> IHelloStarknetDispatcher {
    let (contract_address, _) = deploy_syscall(
        HelloStarknet::TEST_CLASS_HASH.try_into().unwrap(), 0, array![].span(), false,
    )
        .unwrap_syscall();
    IHelloStarknetDispatcher { contract_address }
}

#[test]
fn test_counter_starts_at_zero() {
    let contract = deploy();
    assert(contract.get_counter() == 0, 'Initial counter should be 0');
}

#[test]
fn test_increment() {
    let contract = deploy();
    contract.increment();
    assert(contract.get_counter() == 1, 'Counter should be 1 after inc');
    contract.increment();
    assert(contract.get_counter() == 2, 'Counter should be 2 after inc');
}

#[test]
fn test_increment_then_decrement() {
    let contract = deploy();
    contract.increment();
    contract.increment();
    contract.decrement();
    assert(contract.get_counter() == 1, 'Counter should be 1');
}

#[test]
#[should_panic(expected: ('Counter cannot go below zero',))]
fn test_decrement_below_zero_panics() {
    let contract = deploy();
    contract.decrement();
}
