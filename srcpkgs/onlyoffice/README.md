## 🏢 Only Office Template
This package provides [OnlyOffice](https://www.onlyoffice.com/), an office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents. This package merely takes the `.deb` release version from the authors, extracts and installs the files as is. Plus, ensures the dependencies are there.
> **Note**: This is not building binaries from source as a proper package should.

The template file is prepared for use with [xbps-src](https://github.com/void-linux/void-packages) in Void Linux. It has a Bash script to check the latest version and update the template.

---
### 🚀 Installation
- Setup:
```
git clone https://github.com/void-linux/void-packages
cd void-packages
./xbps-src binary-bootstrap
### !! Do it above once **if not** done already!!

git clone https://github.com/gqtn/void-linux/
cp -r /path/to/gqtn/void-linux/srcpkgs/onlyoffice /path/to/void-packages/srcpkgs/
```
- To install and update OnlyOffice:
```
### To update
cd srcpkg/onlyoffice
./update.sh
./xbps-src pkg onlyoffice
sudo xbps-install --repository hostdir/binpkgs onlyoffice
```
