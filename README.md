# Blockchain Demo App

A SwiftUI iOS application that serves as a client interface for the [Swift-Blockchain](https://github.com/xiaohsun/Swift-Blockchain) server implementation.
<br/>
<p align="leading">
  <img src="https://github.com/xiaohsun/Blockchain_Demo_App/raw/main/imgs/Simulator%20Screenshot%20-%202025-05-16%20at%2017.24.01.png" width="200"/>
  <img src="https://github.com/xiaohsun/Blockchain_Demo_App/raw/main/imgs/Simulator%20Screenshot%20-%202025-05-16%20at%2017.24.26.png" width="200"/>
  <img src="https://github.com/xiaohsun/Blockchain_Demo_App/raw/main/imgs/Simulator%20Screenshot%20-%202025-05-16%20at%2017.25.16.png" width="200"/>
  <img src="https://github.com/xiaohsun/Blockchain_Demo_App/raw/main/imgs/Simulator%20Screenshot%20-%202025-05-16%20at%2017.25.21.png" width="200"/>
</p>
<br/>
<br/>
  
## Overview

This iOS application provides a user-friendly interface to interact with a blockchain server built with Swift and the Vapor framework. The app allows users to:

- View the current state of the blockchain
- Mine new blocks
- Create and submit new transactions
- Manage blockchain nodes
- Visualize the blockchain data
<br/>
  
## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 13.0+
- Swift 5.5+
- A running instance of the [Swift-Blockchain](https://github.com/xiaohsun/Swift-Blockchain) server
<br/>
  
## Setup & Installation

1. Clone this repository and the [Swift-Blockchain](https://github.com/xiaohsun/Swift-Blockchain) repository
2. Start the Swift-Blockchain server instance
3. Open `Blockchain_demo.xcodeproj` in Xcode
4. Configure the server URL in the app (default is `http://localhost:8080`)
5. Build and run the app on your device or simulator
<br/>
  
## Features

### Blockchain View
The main view displays the current state of the blockchain, showing blocks, their hashes, and included transactions.

### Mining View
Allows users to mine new blocks and see the mining process in real-time.

### Transactions View
Interface for creating new transactions by specifying:
- Sender address
- Recipient address
- Amount

### Nodes View
Manage consensus between different blockchain nodes:
- Register new nodes
- Resolve consensus issues by synchronizing with the longest valid chain
<br/>
  
## Connection to Swift-Blockchain Server

This app connects to the [Swift-Blockchain](https://github.com/xiaohsun/Swift-Blockchain) backend server, which implements:

- Proof of Work algorithm
- Transaction validation
- Consensus mechanism for distributed nodes
- RESTful API for interaction

The app communicates with the server using the following endpoints:

- `GET /chain` - View the blockchain
- `GET /mine` - Mine a new block
- `POST /transactions/new` - Create a new transaction
- `POST /nodes/register` - Register new nodes
- `GET /nodes/resolve` - Resolve consensus issues
<br/>
  
## Contact

Author: Bo-Hsun Hsu  
Email: bohsunhsu@gmail.com
<br/>
<br/>
  
## License

This project is available under the MIT License. 
