# Rise

Launcher and distribution for the Rise client.

## Running

Double-click **`Rise.bat`**. It starts `RiseLauncher.jar` with `javaw`, so no console
window ever appears.

On first run the launcher checks `%APPDATA%\rise` for `Demise.jar`, `java\bin`,
`natives\` and `assets\`. If any are missing it blurs the page, shows the installer
card, and downloads everything from `manifest.txt`.

## Publishing a new version

1. Run **`package-release.ps1`**. It writes `release\` containing `java.zip`,
   `assets.zip`, `natives.zip`, `data.zip` and `Demise.jar`.
2. Create a GitHub **Release** and upload those as assets.
   They cannot go in the repo — git rejects files over 100 MB and `Demise.jar` is
   roughly 398 MB. Release assets allow up to 2 GB each.
3. Edit `manifest.txt` so each url points at the uploaded asset.
4. Edit `BASE_URL` in `launcher-src/rise/Launcher.java` to your repo, rebuild the jar
   (see below), and commit.

Commit only: `RiseLauncher.jar`, `Rise.bat`, `manifest.txt`, `logo.png`,
`background.jpg`, `launcher-src/`, `README.md`, `.gitignore`.

## Rebuilding the launcher

```
cd launcher-src
javac -encoding UTF-8 -d out rise\*.java
copy res\* out\
jar --create --file ..\RiseLauncher.jar --main-class rise.Launcher -C out .
```

Needs JDK 17+. The images in `res\` are embedded into the jar, so the launcher has its
logo, background and fallback skin with no external files.

## Layout

| Path | What |
|---|---|
| `RiseLauncher.jar` | the launcher |
| `Rise.bat` | starts it without a console |
| `manifest.txt` | what the installer downloads |
| `launcher.properties` | remembered username and RAM (created on first save) |
| `java\` | bundled runtime, used to launch the game |
| `Demise.jar` | the client |
| `data\` | game directory (config, saves, screenshots) |
| `logs\` | one log per launch |
