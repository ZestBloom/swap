# Swap

Swap is a reach app that locks a x tokens inside a smart contract to swap with another x tokens.

## Activation

0.35 ALGO

## Participants
### Auctioneer
Alice sets the swap params.
### Depositor
Depositor is whomever deposits token a.

## Views
None
## API
### swap
Give token b. Receive token a.
### close
Assuming remaining token a is 0, then anyone may close teh app.

## Steps

1. Alice comes along and reveals amount, tokA, and tokB
1. Depositor comes along deposits amount of tokA
1. Api (swap) allows from from tokB to tokA until amount remaining is zero
2. Api (close) allows contract to be closed to Depositor if balance of tokA is zero

## quickstart

commands
```bash
git clone git@github.com:ZestBloom/swap.git
cd swap
source np.sh 
np
```

output
```json
{"info":66944916}
```

## how does it work

NP provides a nonintrusive wrapper allowing apps to be configurable before deployment and created on the fly without incurring global storage.   
Connect to the constructor and receive an app id.   
Activate the app by paying for deployment and storage cost. 
After activation, your RApp takes control.

## how to activate my app

In your the frontend of your NPR included Contractee participation. Currently, a placeholder fee is required for activation. Later an appropriate fee amount will be used.

```js
ctc = acc.contract(backend, id)
backend.Contractee(ctc, {})
```

## terms

- NP - Nash Protocol
- RAap - Reach App
- NPR - NP Reach App
- Activation - Hand off between constructor and contractee require fee to pay for deployment and storage cost incurred by constructor

## dependencies

- Reach development environment (reach compiler)
- sed - stream editor
- grep - pattern matching
- curl - request remote resource


