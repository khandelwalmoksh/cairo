# Cairo – Starknet Smart Contracts Learning Repository

A hands-on learning repository for writing smart contracts in [Cairo](https://www.cairo-lang.org/) and deploying them on [Starknet](https://starknet.io/) — Ethereum's ZK-rollup Layer 2.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Setup](#project-setup)
- [Examples](#examples)
- [Running Tests](#running-tests)
- [Learning Resources](#learning-resources)

---

## Prerequisites

Install [Scarb](https://docs.swmansion.com/scarb/) — the Cairo package manager and build tool:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```

Verify the installation:

```bash
scarb --version
```

---

## Project Setup

```bash
# Clone this repository
git clone https://github.com/khandelwalmoksh/cairo.git
cd cairo

# Build the project
scarb build

# Run tests
scarb test
```

---

## Examples

| Contract | Description |
|---|---|
| [`hello_starknet`](src/hello_starknet.cairo) | Basic counter contract — read & write storage |
| [`simple_storage`](src/simple_storage.cairo) | Store and retrieve a value on-chain |
| [`erc20`](src/erc20.cairo) | Fungible token following the ERC-20 standard |
| [`ownable`](src/ownable.cairo) | Ownership pattern with transfer and access control |
| [`events`](src/events.cairo) | Emitting and reading on-chain events |

---

## Running Tests

```bash
scarb test
```

Tests live in `src/tests/` and use the built-in Cairo test runner.

---

## Learning Resources

- [The Cairo Book](https://book.cairo-lang.org/)
- [Starknet Documentation](https://docs.starknet.io/)
- [OpenZeppelin Contracts for Cairo](https://github.com/OpenZeppelin/cairo-contracts)
- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/)
- [Cairo Playground](https://www.cairo-lang.org/playground/)

