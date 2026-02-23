use cairo_starknet_learning::erc20::{ERC20, IERC20Dispatcher, IERC20DispatcherTrait};
use starknet::syscalls::deploy_syscall;
use starknet::{ContractAddress, SyscallResultTrait};
use starknet::testing::set_caller_address;

const INITIAL_SUPPLY: u256 = 1_000_000_u256;

fn owner() -> ContractAddress {
    'owner'.try_into().unwrap()
}

fn alice() -> ContractAddress {
    'alice'.try_into().unwrap()
}

fn deploy() -> IERC20Dispatcher {
    let recipient = owner();
    let mut calldata = array![];
    calldata.append('MyToken'); // name
    calldata.append('MTK'); // symbol
    calldata.append(18); // decimals
    // u256 is two felts (low, high)
    calldata.append(INITIAL_SUPPLY.low.into());
    calldata.append(INITIAL_SUPPLY.high.into());
    calldata.append(recipient.into());

    let (contract_address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false,
    )
        .unwrap_syscall();
    IERC20Dispatcher { contract_address }
}

#[test]
fn test_metadata() {
    let token = deploy();
    assert(token.name() == 'MyToken', 'Wrong name');
    assert(token.symbol() == 'MTK', 'Wrong symbol');
    assert(token.decimals() == 18, 'Wrong decimals');
}

#[test]
fn test_initial_supply_minted_to_owner() {
    let token = deploy();
    assert(token.total_supply() == INITIAL_SUPPLY, 'Wrong total supply');
    assert(token.balance_of(owner()) == INITIAL_SUPPLY, 'Wrong owner balance');
}

#[test]
fn test_transfer() {
    let token = deploy();
    set_caller_address(owner());
    token.transfer(alice(), 500_u256);
    assert(token.balance_of(alice()) == 500_u256, 'Alice balance wrong');
    assert(token.balance_of(owner()) == INITIAL_SUPPLY - 500_u256, 'Owner balance wrong');
}

#[test]
#[should_panic(expected: ('ERC20: insufficient balance',))]
fn test_transfer_insufficient_balance_panics() {
    let token = deploy();
    set_caller_address(alice());
    token.transfer(owner(), 1_u256);
}

#[test]
fn test_approve_and_transfer_from() {
    let token = deploy();
    set_caller_address(owner());
    token.approve(alice(), 200_u256);
    assert(token.allowance(owner(), alice()) == 200_u256, 'Allowance wrong');

    set_caller_address(alice());
    token.transfer_from(owner(), alice(), 200_u256);
    assert(token.balance_of(alice()) == 200_u256, 'Alice balance wrong');
    assert(token.allowance(owner(), alice()) == 0_u256, 'Allowance should be 0');
}
