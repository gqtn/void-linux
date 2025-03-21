## 🦁 Brave Browser Template
This package provides [Brave Browser](https://brave.com/), the browser based on Chromium with privacy in mind and a built in ad blocker. This package merely takes the `.deb` release version from the authors, extracts and installs the files as is. Plus, ensures the dependencies are there.
> **Note**: This is not building binaries from source as a proper package should.

The template file is prepared for use with [xbps-src](https://github.com/void-linux/void-packages) in Void Linux. It has a Bash script to check the latest version and update the template.

---
### 🚀 Installation
- Setup: (do it once if **not done** already!)
```
git clone https://github.com/void-linux/void-packages
cd void-packages
./xbps-src binary-bootstrap
git clone https://github.com/gqtn/void-linux/
cp -r /path/to/gqtn/void-linux/srcpkgs/brave-bin /path/to/void-packages/srcpkgs/
```
- To install and update Brave Beta:
```
cd srcpkg/brave-beta-bin
./update.sh
./xbps-src pkg brave-beta-bin
sudo xbps-install --repository hostdir/binpkgs brave-bin
```

---
### ❗ Questions:
*"Why won't Brave be in the XBPS repositories any time soon?"*
> The developers are somewhat hostile to using build-server infrastructure to build any additional forks of Chromium or Firefox, as well as generally citing more variable reasons with the former ranging from patched code to the difficulty of packaging a browser and followed by warnings to those who would maintain (and cross compile) the thing.
> You can read more about it [here](https://github.com/void-linux/void-packages/issues/5444)

*"Why don't you update the template directly in your repository every time?"*
> Since this is a Beta version, it is preferable that you evaluate (in the changelog available on the website) the changes in each version and decide when you want — or not — to update it. And also, I don't have time to update continuously.

*"Why do you use the `.deb` version instead of building binaries from source?"*
> I'm still exploring some features of Void Linux and XBPS. So, this is on the roadmap. Any help, recommendation or advice will be welcome (just add it via issue).
