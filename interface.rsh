"reach 0.1";
"use strict";
// -----------------------------------------------
// Name: ALGO/ETH/CFX Swap
// Author: Nicholas Shellabarger
// Version: 0.1.0 - add exchange
// Requires Reach v0.1.7 (stable)
// ----------------------------------------------
export const Participants = () => [
  Participant("Alice", {
    getParams: Fun(
      [],
      Object({
        amount: UInt,
        exchange: UInt,
        tokA: Token,
        tokB: Token,
      })
    ),
  }),
  Participant("Depositor", {
    signal: Fun([], Null),
  }),
];
export const Views = () => [
  View({
    remaining: UInt,
  }),
];
export const Api = () => [
  API({
    swap: Fun([UInt], Null),
    close: Fun([], Null),
  }),
];
export const App = (map) => {
  const [_, { tok }, [Alice, Depositor], [v], [a]] = map;
  Alice.only(() => {
    const { amount, exchange, tokA, tokB } = declassify(interact.getParams());
    assume(amount > 0);
    assume(amount % exchange == 0);
    assume(tok != tokA);
    assume(tok != tokB);
    assume(tokA != tokB);
  });
  Alice.publish(amount, exchange, tokA, tokB);
  commit();
  Depositor.pay([0, [amount, tokA]]);
  v.remaining.set(amount);
  Depositor.only(() => interact.signal());
  require(amount > 0);
  require(amount % exchange == 0);
  require(tok != tokA);
  require(tok != tokB);
  require(tokA != tokB);
  const [keepGoing, remaining] = parallelReduce([true, amount])
    .define(() => {
      v.remaining.set(remaining);
    })
    .invariant(
      balance() >= 0 &&
        balance(tok) == 0 &&
        balance(tokA) >= 0 &&
        balance(tokB) >= 0
    )
    .while(keepGoing)
    .paySpec([tokB])
    .api(
      a.swap,
      (amt) => assume(remaining - amt >= 0 && balance(tokA) >= amt),
      (amt) => [0, [amt * exchange, tokB]],
      (amt, k) => {
        require(remaining - amt >= 0 && balance(tokA) >= amt);
        transfer([0, [amt, tokA]]).to(this);
        k(null);
        return [true, remaining - amt];
      }
    )
    .api(
      a.close,
      () => assume(remaining == 0),
      () => [0, [0, tokB]],
      (k) => {
        require(remaining == 0);
        k(null);
        return [false, 0];
      }
    )
    .timeout(false);
  transfer(balance()).to(Depositor);
  transfer(balance(tok), tok).to(Depositor);
  transfer(balance(tokA), tokA).to(Depositor);
  transfer(balance(tokB), tokB).to(Depositor);
  commit();
  exit();
};
// ----------------------------------------------
