## WinBox tool for Void Linux

---

### Information:

Winbox is a small utility that allows users to administer MikroTik RouterOS through a fast and simple graphical user interface (GUI). It can be run on Windows, Linux, and macOS, and is used for configuring and managing MikroTik routers.

---
### About the Template:

The template follows a few steps:

1. Downloads the binary from the source (a `.zip` file)
2. Creates some temporary directories for installation
3. Installs the binary directly
4. Uses the icon directly from the source
5. Creates the `.desktop` file to facilitate execution

---
### To install:

```
# Do it once if not done already!
git clone https://github.com/void-linux/void-packages
cd void-packages
./xbps-src binary-bootstrap

# If yes:
git clone https://github.com/gqtn/void-linux/
cp -r /path/to/gqtn/void-linux/srcpkgs/winbox/ /path/to/void-packages/srcpkgs/
./xbps-src pkg winbox

# If you download the `xtools` package: 
xi winbox 

# If not:
sudo xbps-install --repository hostdir/binpkgs winbox
```

---
### Updating

I have not yet checked or created a script to check for updates on the main site and put them in the template. So please check this yourself and update the template. I cannot guarantee that the template will always be updated.

If you have any questions, please open an issue.
