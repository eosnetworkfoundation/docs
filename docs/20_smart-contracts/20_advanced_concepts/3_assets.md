---
title: Assets
---

An `asset` is a special type made specifically for blockchain tokens.

The two primary components of an asset are the `symbol` and the `amount`.

The `symbol` is a combination of a string and a number. The string is the
name of the token and the number is the number of decimal places.

The `amount` is a 64-bit signed integer.

## Defining an Asset

If you want to use assets in your contract, you need to include the `asset.hpp`:

```cpp
#include <eosio/asset.hpp>
```

Then you can use the asset type in your contract. Let's set up a symbol first:

```cpp
symbol TOKEN_SYMBOL = symbol("COOL", 8);
// or
symbol TOKEN_SYMBOL("COOL", 8);
```

This creates a symbol with the name `COOL` and 8 decimal places. 

Now we can create an asset:

```cpp
asset my_asset = asset(1'00000000, TOKEN_SYMBOL);
// or
asset my_asset(1'00000000, TOKEN_SYMBOL);
```

The above declaration means that the string representation of the asset will look like this: `1.00000000 COOL`.

## Asset Operators

The asset type has a few operators that you can use to manipulate assets.

### Mathematical Operations

You can add two assets together:

```cpp
asset a = asset(1'00000000, TOKEN_SYMBOL);
asset b = asset(2'00000000, TOKEN_SYMBOL);
asset c = a + b;
```

This will result in `c` being equal to `3.00000000 COOL`. You could alternatively also just 
add the two assets' amounts together directly:

```cpp
uint64_t c = a.amount + b.amount;
```

> ⚠ The two assets must have the same symbol.
> 
> Doing mathematical operations with different symbols will result in an error during execution. 
> You should always make sure that the symbols match when working with assets inside your smart contracts.

Other mathematical operations are also available:

```cpp
asset a = asset(1'00000000, TOKEN_SYMBOL);
asset b = asset(2'00000000, TOKEN_SYMBOL);
asset c = a - b; 
asset d = a * 2;
asset e = a / 2; 
e += a; 
e -= a; 
e *= 2; 
e /= 2;
```

## Comparison Operators

You can compare two assets with each other:

```cpp
asset a = asset(1'00000000, TOKEN_SYMBOL);
asset b = asset(2'00000000, TOKEN_SYMBOL);
bool c = a > b;
bool d = a < b; 
bool e = a == b; 
bool f = a != b;
```

## Printing assets

If you want to print assets in either an error message or console log, you can use the `to_string()` method.

```cpp
asset a = asset(1'00000000, TOKEN_SYMBOL);
check(false, "You have " + a.to_string() + " tokens.");
```

## Checking validity

You should always check if an asset is valid before using it. This is done with the `is_valid()` method.
This checks if the asset is within the range of valid values and whether or not the symbol is valid.

```cpp
asset a = asset(1'00000000, TOKEN_SYMBOL);
check(a.is_valid(), "Asset is not valid.");
```



## Overflow considerations

The asset type comes with built-in overflow/underflow protection.

This means that if you try to add two assets together and the result is larger than the maximum value of a 64-bit integer, an error will be thrown.

It will not allow you to create an asset with an amount that is not within the range of a signed 64-bit integer.






