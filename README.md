# BeEF Termux

How To Install BeEF Tool In Termux

## Overview

**BeEF** (Browser Exploitation Framework) is a powerful penetration testing tool that focuses on the web browser as an attack vector. This repository provides a guide and installation scripts for running BeEF on **Termux**, an Android terminal emulator and Linux environment.

## What is BeEF?

BeEF is designed to demonstrate the actual security risks of browser exploitation to security professionals and penetration testers. It allows you to:

- Hook browsers and gather intelligence about target systems
- Exploit vulnerabilities in web browsers
- Execute various attack modules on compromised browsers
- Perform social engineering and client-side exploitation
- Chain multiple vectors together for sophisticated attacks

## What is Termux?

**Termux** is an Android terminal emulator and Linux environment that brings powerful command-line tools to your Android device. It allows you to run Unix/Linux applications on Android without rooting your device.

## Prerequisites

- **Termux** installed on your Android device (available on Google Play Store or F-Droid)
- At least **2GB free storage space**
- Stable internet connection for downloading dependencies
- Basic Linux/terminal command knowledge

## Installation

### Quick Start

1. Open Termux and update package lists:
```bash
pkg update && pkg upgrade
```

2. Run the installation script:
```bash
bash install.sh
```

3. Follow the on-screen prompts to complete the installation.

### Manual Installation

If you prefer manual installation, follow these steps:

1. **Install dependencies:**
```bash
pkg install python ruby curl git nodejs-lts
```

2. **Clone or download BeEF:**
```bash
git clone https://github.com/beefproject/beef.git
cd beef
```

3. **Install Ruby gems:**
```bash
gem install bundler
bundle install
```

4. **Start BeEF:**
```bash
ruby beef
```

## Usage

Once BeEF is installed and running:

1. Access the BeEF UI at: `http://localhost:3000/ui/panel`
2. Default credentials are typically: `beef` / `beef`
3. Copy the hook URL to test browsers
4. Use various attack modules to compromise target browsers

## Important Notes

⚠️ **Legal Disclaimer:**
- Only use BeEF on systems you own or have explicit permission to test
- Unauthorized access to computer systems is illegal
- This tool is for educational and authorized security testing purposes only
- Always get written permission before performing penetration tests

## Features

- Browser hooked exploitation
- Extensible module system
- Advanced payload delivery
- Cross-browser compatibility testing
- Social engineering modules
- XSS and CSRF attack vectors

## Troubleshooting

### Common Issues

**Issue: Ruby/Python not found**
```bash
pkg install python ruby
```

**Issue: Port 3000 already in use**
- Change the port in BeEF configuration or kill the process using that port

**Issue: Storage space errors**
- Free up space on your device and ensure adequate storage for BeEF and dependencies

**Issue: Network connection problems**
- Verify internet connectivity
- Check firewall settings
- Restart Termux and try again

## Requirements

- Termux application
- Linux/Unix knowledge
- Ethical hacking knowledge
- Permission to test target systems

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## References

- [BeEF Official Project](https://beefproject.com/)
- [Termux Documentation](https://termux.com/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

## License

This repository is provided as-is for educational purposes. BeEF itself is licensed under GPL v3.

## Support

For issues specific to this Termux guide, open an issue on this repository.

For BeEF-specific issues, visit the [BeEF GitHub repository](https://github.com/beefproject/beef).
---

**Disclaimer:** This tool should only be used for authorized security testing and educational purposes. Unauthorized access or use is illegal.
