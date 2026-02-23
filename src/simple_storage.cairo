/// # SimpleStorage
///
/// Stores a single felt252 value on-chain.
/// Demonstrates: felt252 type, basic setter/getter pattern.
#[starknet::contract]
pub mod SimpleStorage {
    #[storage]
    struct Storage {
        stored_value: felt252,
    }

    #[abi(embed_v0)]
    impl SimpleStorageImpl of super::ISimpleStorage<ContractState> {
        /// Write a new value to storage.
        fn set(ref self: ContractState, value: felt252) {
            self.stored_value.write(value);
        }

        /// Read the stored value.
        fn get(self: @ContractState) -> felt252 {
            self.stored_value.read()
        }
    }
}

/// Interface for SimpleStorage.
#[starknet::interface]
pub trait ISimpleStorage<TContractState> {
    fn set(ref self: TContractState, value: felt252);
    fn get(self: @TContractState) -> felt252;
}
