---
title: "Before You Begin"
---

## Step 1: Install Leap binaries
To get started as quickly as possible we recommend using pre-built binaries. Building from source is a more advanced option that will set you back an hour or more, and you may still encounter build errors.

[[info]]
| You can find how to build Antelope from source [here](https://github.com/AntelopeIO/leap#building-from-source).

To install the latest Leap binaries, visit the Leap [Software Installation](https://github.com/antelopeIO/leap/#software-installation) page.

[[warning]]
| If you have previous Leap versions installed on your system, please uninstall before proceeding. For detailed instructions, visit the Leap [Software Installation](https://github.com/antelopeIO/leap/#software-installation) page.

## Step 2: Setup a development directory, stick to it.
You're going to need to pick a directory to work from, it's suggested to create a `contracts` directory somewhere on your local drive.
```shell
mkdir contracts
cd contracts
```

## Step 3: Enter your local directory below.
Get the path of that directory and save it for later, as you're going to need it, you can use the following command to get your absolute path.
```
pwd
```

Enter the absolute path to your contract directory below, and it will be inserted throughout the documentation to make your life a bit easier. _This functionality requires cookies_

![cli](../images/cli_2.2.2.gif)

<div class="antelope-helper-box">
    <form id="CONTRACTS_DIR">
        <label>Absolute Path to Contract Directory</label>
        <input class="helper-cookie" name="CONTRACTS_DIR" type="text" />
        <input type="submit" />
        <span></span>
    </form>
</div>

## What's Next?
- [Install the CDT](./04_install-the-CDT.md): Steps to install the Antelope Contract Development Toolkit (CDT) on your system.
