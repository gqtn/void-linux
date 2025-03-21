## 🚀 Welcome!

![VoidLinux](./banner.png)

## Goodies for Void Linux

[Void Linux](https://voidlinux.org/) is amazingly fast, lightweight, bare-bones and adheres to unix philosophies better than any other popular GNU/Linux distros. With Void Linux we can have the fun of building a system from ground up. Not convinced yet? Here are some more great reasons to try Void:

- Not a fork
- Stable rolling release
- It uses `runit` as the init system and service supervisor
- Supports `glibc` and `musl`
- Native system package manager, written from scratch

This repository, then, tries to gather some good recommendations, articles and templates that I have tried over time. I hope you like it!

---
### 📰 Articles
Inside this folder, you will find good files and information about Void Linux, such as: installation tricks, recommendations and my personal experience.
> Note: this will be constantly updated, as I progress.

---
### 📦 srcpkgs
Inside this folder, you can find some ready-made recipes that I made to make things easier (templates) for programs that are not directly in the official repository.
Each template will have its own recommendation (`README.md`) to guide the installation and answer questions, but in general, the sequence will be:
```
# Step 1: 
sudo xbps-install xtools

# Step 2:
git clone --depth=1 https://github.com/void-linux/void-packages
cd void-packages

# Step 3: (Do it if not done already)
./xbps-src binary-bootstrap

# Step 4: (To copy all the packages of my repository)
git clone https://github.com/gqtn/void-linux
cp -r /path/to/this/repo/srcpkgs/* /path/to/void-packages/srcpkgs/
./xbps-src pkg <package name>
xi <package name>
```
> Most templates contain a Bash script to make updating easier.

---
### 🛎️ Contributions
If you have any suggestions for improvements, if something didn't work as expected or if you want to request a package, feel free to open an issue.
