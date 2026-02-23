/// # Events
///
/// Demonstrates how to define, emit, and filter on-chain events in Cairo.
use starknet::ContractAddress;

#[starknet::interface]
pub trait IEvents<TContractState> {
    fn send_message(ref self: TContractState, message: felt252);
    fn deposit(ref self: TContractState, amount: u256);
}

#[starknet::contract]
pub mod Events {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {}

    /// All events the contract can emit.
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        MessageSent: MessageSent,
        Deposited: Deposited,
    }

    /// Emitted when a user sends a message.
    #[derive(Drop, starknet::Event)]
    pub struct MessageSent {
        #[key]
        pub sender: ContractAddress,
        pub message: felt252,
    }

    /// Emitted when a user makes a deposit.
    #[derive(Drop, starknet::Event)]
    pub struct Deposited {
        #[key]
        pub depositor: ContractAddress,
        pub amount: u256,
    }

    #[abi(embed_v0)]
    impl EventsImpl of super::IEvents<ContractState> {
        fn send_message(ref self: ContractState, message: felt252) {
            let sender = get_caller_address();
            self.emit(MessageSent { sender, message });
        }

        fn deposit(ref self: ContractState, amount: u256) {
            assert(amount > 0, 'Amount must be positive');
            let depositor = get_caller_address();
            self.emit(Deposited { depositor, amount });
        }
    }
}
