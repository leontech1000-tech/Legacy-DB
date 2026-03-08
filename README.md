# Legacy-DB

`Legacy-DB` is the catalog repo for Fire Launcher.

Fire Launcher reads `catalog.json` from the root of this repository. Each fork family contains one or more version entries. A version can either:

- point at a direct `packageUrl`, or
- point at a GitHub Release asset by `releaseTag` + `assetFileName`

## Add a new version

1. Upload a `.zip` package to a GitHub Release in this repo.
2. Add a new version block inside the correct family in `catalog.json`.
3. Set:
   - `id`
   - `versionLabel`
   - `displayName`
   - `installFolderName`
   - `executableRelativePath`
   - `releaseTag`
   - `assetFileName`
4. Commit and push.

Fire Launcher will then be able to sync the catalog, show the new version in the launcher, and download it into the local forks folder.

## Notes

- Keep packages as extracted build `.zip` files.
- `executableRelativePath` is relative to the install root after extraction.
- `showInLauncherByDefault` controls whether new profile DBs expose that family automatically.
