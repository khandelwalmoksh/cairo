/// # HelloStarknet
///
/// A minimal Starknet contract that stores a counter.
/// Demonstrates: storage variables, read/write entrypoints.
#[starknet::contract]
pub mod HelloStarknet {
    #[storage]
    struct Storage {
        counter: u128,
    }

    #[abi(embed_v0)]
    impl HelloStarknetImpl of super::IHelloStarknet<ContractState> {
        /// Increment the counter by one.
        fn increment(ref self: ContractState) {
            self.counter.write(self.counter.read() + 1);
        }

        /// Decrement the counter by one. Panics if the counter is already zero.
        fn decrement(ref self: ContractState) {
            let current = self.counter.read();
            assert(current > 0, 'Counter cannot go below zero');
            self.counter.write(current - 1);
        }

        /// Return the current counter value.
        fn get_counter(self: @ContractState) -> u128 {
            self.counter.read()
        }
    }
}

/// Interface for HelloStarknet.
#[starknet::interface]
pub trait IHelloStarknet<TContractState> {
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
    fn get_counter(self: @TContractState) -> u128;
}
