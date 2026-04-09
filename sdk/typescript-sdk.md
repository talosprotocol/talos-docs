# TypeScript SDK

The `talos-sdk-ts` package provides TypeScript/JavaScript bindings for the Talos Protocol.

## Installation

```bash
npm install @talosprotocol/sdk
```

Or with yarn:

```bash
yarn add @talosprotocol/sdk
```

## Standards-First A2A v1

Use `A2AJsonRpcClient` for the public A2A v1 Agent Card and `/rpc` task surface. Talos secure channels remain a separate extension layered on top of the standard Agent Card.

```typescript
import {
  A2AJsonRpcClient,
  TALOS_SECURE_CHANNELS_EXTENSION,
} from '@talosprotocol/sdk';

const client = new A2AJsonRpcClient('https://gateway.talos.example', {
  apiToken: process.env.TALOS_API_TOKEN,
});

const card = await client.getAgentCard();
const interfaces = await client.supportedInterfaces(card);

if (await client.supportsExtension(TALOS_SECURE_CHANNELS_EXTENSION, card)) {
  console.log('Talos secure-channel extension available');
}

const result = await client.sendMessage('Hello from TypeScript');
console.log(result.task);
console.log(interfaces[0]?.url);
```

The helper methods emit canonical A2A v1 JSON-RPC operations such as `GetExtendedAgentCard`, `SendMessage`, `ListTasks`, and `SubscribeToTask`. Talos alias methods are kept only as a gateway migration fallback.

For official upstream servers that are not Talos-style `/rpc` targets, the TypeScript client also supports explicit compatibility profiles:

```typescript
const legacyV03 = new A2AJsonRpcClient("http://127.0.0.1:9999", {
  interopProfile: "upstream_v0_3",
});

const javaHybrid = new A2AJsonRpcClient("http://127.0.0.1:9999", {
  interopProfile: "upstream_java_hybrid",
});
```

These profiles are opt-in. `upstream_v0_3` remaps discovery and RPC to upstream `v0.3.0` conventions such as `agent/getAuthenticatedExtendedCard` and `message/send`, while `upstream_java_hybrid` uses the Agent Card's root JSON-RPC URL plus Java-style enum roles for the official Java sample. Canonical `/rpc` remains the default.

For a real HTTP smoke against the local reference fixture, build the SDK and run:

```bash
cd sdks/typescript
npm --workspace @talosprotocol/sdk run build
node examples/a2a_v1_live_interop.mjs --gateway-url http://127.0.0.1:8011 --api-token sdk-token --prompt "hello" --exercise-streams
```

## Quick Start

```typescript
import { TalosClient } from '@talosprotocol/sdk';

// Create a client
const client = new TalosClient({
  agentId: 'my-agent',
  privateKey: process.env.TALOS_PRIVATE_KEY,
});

// Establish secure session
await client.connect(peerId, peerBundle);

// Send encrypted message
await client.send(peerId, Buffer.from('Hello with forward secrecy!'));

// Receive messages
client.on('message', (msg) => {
  console.log('Received:', msg.payload);
});
```

## API Reference

### TalosClient

```typescript
interface TalosClientOptions {
  agentId: string;
  privateKey?: string;
  gatewayUrl?: string;  // default: http://localhost:8000
}

class TalosClient {
  constructor(options: TalosClientOptions);
  
  connect(peerId: string, peerBundle: KeyBundle): Promise<void>;
  send(peerId: string, payload: Buffer): Promise<void>;
  close(): Promise<void>;
  
  on(event: 'message', handler: (msg: Message) => void): void;
  on(event: 'error', handler: (err: Error) => void): void;
}
```

### Cursor Derivation

Use contracts helpers for cursor operations:

```typescript
import { deriveCursor, base64urlEncode } from '@talosprotocol/contracts';

// Derive cursor from timestamp and event ID
const cursor = deriveCursor({
  timestamp: Date.now(),
  eventId: 'evt_123',
});

// Encode for transmission
const encoded = base64urlEncode(cursor);
```

### Capability Tokens

```typescript
import { createCapabilityToken, verifyCapabilityToken } from '@talosprotocol/sdk';

// Create a scoped capability
const token = createCapabilityToken({
  subject: 'agent:bob',
  resource: 'file:///data/report.pdf',
  actions: ['read'],
  expiresAt: Date.now() + 3600000, // 1 hour
});

// Verify token
const isValid = verifyCapabilityToken(token, publicKey);
```

## Browser Support

For browser environments, import from the browser entry:

```typescript
import { TalosClient } from '@talosprotocol/sdk/browser';
```

**Note:** Do not use `btoa`/`atob` directly. Use `@talosprotocol/contracts` helpers for encoding.

## Contract Compliance

The SDK consumes types and helpers from `@talosprotocol/contracts`:

```typescript
// Contracts are source of truth
import { 
  AuditEventSchema,
  deriveCursor,
  base64urlEncode,
  base64urlDecode,
} from '@talosprotocol/contracts';
```

## Versioning

| SDK Version | Protocol Version | Contracts Version |
|-------------|------------------|-------------------|
| 1.x | v4.0 | 1.x |

## Configuration

### Gateway URL

```typescript
const client = new TalosClient({
  agentId: 'my-agent',
  gatewayUrl: 'https://gateway.talos.talosprotocol.com',
});
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `TALOS_GATEWAY_URL` | Gateway endpoint |
| `TALOS_PRIVATE_KEY` | Agent private key (hex) |
| `TALOS_ENV` | `production` or `test` |

## Error Handling

```typescript
import { TalosError } from '@talosprotocol/sdk';

try {
  await client.send(peerId, payload);
} catch (err) {
  if (err instanceof TalosError) {
    console.error('Talos error:', err.code, err.message);
  }
}
```

## Development

```bash
cd sdks/typescript

make install    # npm ci
make build      # npm run build
make test       # npm test
make lint       # npm run lint
```

## Examples

See the [examples/](../../examples/) directory for:
- Basic messaging
- MCP tool invocation
- Capability token flow
- Audit proof verification
