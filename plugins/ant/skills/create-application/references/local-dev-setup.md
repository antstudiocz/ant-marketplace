# Local Development Setup

Use this reference when the chosen implementation path requires a tool the requester does not have, or when the requester is unsure whether their machine is ready.

Do not continue into implementation planning until the requester either verifies the required tools or explicitly chooses a reduced-scope path that does not need them.

## Setup Workflow

1. Ask for the user's operating system: macOS, Windows, Linux, or cloud-only.
2. Ask which required tools are already installed: Git, Bun, Docker Desktop or Docker Engine, editor, terminal.
3. Explain why each missing tool is needed in plain language.
4. Give OS-specific steps for only the missing tools.
5. Ask the user to run the verification commands and paste the result.
6. If installation fails, troubleshoot the failing step before changing architecture.

## Verification Commands

Use these checks after installation:

```bash
git --version
bun --version
docker --version
docker compose version
docker run hello-world
```

If Docker is not needed for the approved path, skip the Docker commands. If an existing project requires Node.js, also ask for:

```bash
node --version
```

## Install Git

Official source: https://git-scm.com/downloads

macOS:

1. First check whether Git already exists:

```bash
git --version
```

2. If macOS prompts to install command line developer tools, accept the prompt and wait for it to finish.
3. If there is no prompt or the install fails, use the official Git macOS download page: https://git-scm.com/downloads/mac
4. Open a new terminal and verify:

```bash
git --version
```

Windows:

1. Open the official Git for Windows page: https://git-scm.com/downloads/win
2. Download and run the installer.
3. Keep the default options unless the project has a specific team standard.
4. Open a new PowerShell or Windows Terminal window and verify:

```powershell
git --version
```

Linux:

1. Use the official Git downloads page to pick the right distribution instructions: https://git-scm.com/downloads
2. On common Debian/Ubuntu-style systems, the usual package is `git`.
3. Verify:

```bash
git --version
```

## Install Bun

Official source: https://bun.sh/docs/installation

macOS and Linux:

1. Run the official Bun install script:

```bash
curl -fsSL https://bun.com/install | bash
```

2. Open a new terminal, or reload the shell profile if the installer asks you to.
3. Verify:

```bash
bun --version
```

Windows:

1. Open PowerShell.
2. Run the official Bun install command:

```powershell
powershell -c "irm bun.sh/install.ps1|iex"
```

3. Open a new PowerShell or Windows Terminal window.
4. Verify:

```powershell
bun --version
```

If `bun` is installed but not found, follow the PATH troubleshooting steps in the official Bun installation docs.

## Install Docker

Docker should be required only when the approved architecture needs containers, a local database service, workers, queues, or a production-like multi-service setup.

macOS:

1. Open Docker's official Mac install guide: https://docs.docker.com/desktop/setup/install/mac-install/
2. Choose the correct installer for Apple Silicon or Intel.
3. Install Docker Desktop and start it from Applications.
4. Wait until Docker Desktop says it is running.
5. Verify:

```bash
docker --version
docker compose version
docker run hello-world
```

Windows:

1. Open Docker's official Windows install guide: https://docs.docker.com/desktop/setup/install/windows-install/
2. Prefer the WSL 2 backend for normal development.
3. If Docker asks to enable WSL 2 or restart Windows, follow the prompt.
4. Start Docker Desktop and wait until it says it is running.
5. Verify in PowerShell or Windows Terminal:

```powershell
docker --version
docker compose version
docker run hello-world
```

For WSL 2 details, use Docker's WSL guide: https://docs.docker.com/desktop/features/wsl/

Linux:

1. Open Docker's official Engine install guide: https://docs.docker.com/engine/install/
2. Choose the distribution-specific page for Ubuntu, Debian, Fedora, CentOS, RHEL, or another supported platform.
3. Follow the official distribution steps.
4. Verify:

```bash
docker --version
docker compose version
docker run hello-world
```

Docker Desktop licensing can matter for larger companies. If commercial use is relevant, point to Docker's official terms instead of guessing whether the user needs a paid subscription.
