# Legacy-DB

`Legacy-DB` is the catalog repo for Fire Launcher.

Fire Launcher reads `catalog.json` from the root of this repository. Each fork family contains one or more version entries. Each current version can point at a repo-backed package folder such as:

- `forks/lcemp/v1.0.2/`
- `forks/lcemp/v1.0.3/`
- `forks/minecraftconsoles/2026-05-08/`

Each version folder contains:

- `package.json`
- `payload/` with the runtime files Fire Launcher downloads

Current catalog families:

- `LCEMP`
- `MinecraftConsoles`

## Add a new version

1. Copy the runtime files into a new version folder under `forks/<family>/<version>/payload/`.
2. Generate `package.json` for that folder.
3. Add a new version block inside the correct family in `catalog.json`.
3. Set:
   - `id`
   - `versionLabel`
   - `displayName`
   - `installFolderName`
   - `executableRelativePath`
   - `packageType` as `repo-folder`
   - `packageUrl` as the repo-relative `package.json` path
4. Commit and push.

Fire Launcher will then be able to sync the catalog, show the new version in the launcher, and download the files from this repo into the local forks folder.

## Notes

- Strip compiler junk before committing runtime folders:
  - `*.pch`
  - `*.pdb`
  - `*.ilk`
  - `*.ipdb`
  - `*.iobj`
  - `*.obj`
  - `*.lib`
  - `*.exp`
- `executableRelativePath` is relative to the install root after download.
- `showInLauncherByDefault` controls whether new profile DBs expose that family automatically.
