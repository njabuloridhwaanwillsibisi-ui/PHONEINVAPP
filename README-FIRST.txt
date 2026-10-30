POCKET STOCK — WEB DEPLOYMENT FILES + NATIVE ANDROID SOURCE

WHAT IS INCLUDED
web/     Ready-to-host web app. No npm, build step, database server, or ChatGPT account needed on your own hosting.
android/ Real native Android project using Java, Android widgets, and SQLite. No WebView and no website dependency.

IMPORTANT: An APK is NOT included. The Android SDK/Gradle toolchain was unavailable in the creation environment. Native Android code has not been compiled or device-tested. CSV parsing was compiled and tested with Java 17. Build and test the Android project before relying on it with your only stock database.

OPTION 1 — DEPLOY THE WEB APP
1. Upload the CONTENTS of web/ to any static HTTPS hosting, preserving filenames together.
2. Open index.html via the hosting URL on your phone.
3. Import a CSV with column headers in the first row.
4. Tap a card to edit all its fields. Use Add item, Delete, search, sort, and View settings.
5. Export CSV to download all current records (including records hidden by search).
6. On Android Chrome, use Add to Home screen. Offline cache needs an initial successful HTTPS visit.

For a computer preview: open a terminal in web/ and run:
  python -m http.server 8080
Visit http://localhost:8080 on that computer. Phone access over an ordinary LAN HTTP address does not support offline installation; use HTTPS hosting for that.

The web app stores records in this browser's local storage. Storage capacity depends on the browser and data length; it reports failed saves. No automatic cross-device sync. Clearing site data removes saved records. Export CSV backups. On your own host the app has no built-in login. Product data is not uploaded to a server by this app.

To update an existing web deployment: change the cache name in sw.js (e.g. pocket-stock-v2), upload all files, then reopen the app online. The old cache may remain until browser storage is cleared; never clear app storage without exporting your records first.

OPTION 2 — BUILD THE NATIVE ANDROID APK ON WINDOWS
1. Install Android Studio from https://developer.android.com/studio
2. Extract this ZIP. In Android Studio choose Open and select the android folder containing settings.gradle.
3. Let Android Studio synchronize. The project uses Android Gradle Plugin 8.7.3, Gradle 8.9, Java 17, and Android SDK Platform 35. Use the bundled JDK, or Java 17. If Android Studio asks for a Gradle installation rather than a wrapper, use the BUILD-APK.ps1 method below.
4. Open SDK Manager and install Android SDK Platform 35, SDK Build-Tools, and Platform-Tools. Accept SDK licenses when Android Studio requests them.
5. Open PowerShell in the android folder and run:
   powershell -ExecutionPolicy Bypass -File .\BUILD-APK.ps1
   This script uses Java/SDK from Android Studio's usual Windows locations and downloads Gradle 8.9 from its official service, checking the SHA-256 checksum.
6. On success, android/PocketStock.apk is created. It is a debug-signed, installable APK for personal testing/use.
7. Copy PocketStock.apk to your Android phone, tap it, and allow installation from that file manager if Android asks. Supports Android 8.0 and later.
8. Open Pocket Stock. No login or internet connection is needed. Import the CSV using the Android file picker.

Alternative IDE build: configure Gradle 8.9 as the project's local Gradle distribution, then Build > Generate App Bundles or APKs > Generate APKs (menu wording varies). Output: app/build/outputs/apk/debug/app-debug.apk.

OPTION 3 — BUILD WITH GITHUB ACTIONS
If you already use GitHub, upload the CONTENTS of android/ as a repository root, including .github/workflows/build-apk.yml. Under Actions choose Build installable Android APK, then Run workflow. Download the PocketStock-installable-APK artifact after a successful run, unzip it, and copy app-debug.apk to the phone. GitHub network access and workflow availability are required. This workflow has not been run here.

ANDROID WORKFLOW
- Import CSV: choose a local file; preview the row/column count; Replace or Append. Append appears only if headers match exactly. Replacement requires confirmation and cannot be undone.
- First CSV row becomes field labels. All values stay as text, preserving leading-zero codes. Comma, semicolon, and tab delimiters are detected.
- Search all columns with multiple words. Tap any product to edit every column.
- Add item starts a blank database with Stock Code, Description, Qty, Unit Cost, Sell Incl, Notes if nothing has been imported.
- Name field chooses the product title shown on cards.
- Undo reverses the latest add/edit/delete until the next item mutation, import, or app restart.
- Export CSV writes all records to a location you choose with Android's file picker.
- Saved data lives in a private SQLite database. Uninstalling the app or clearing app data deletes it. Export backups first.
- No network permission, analytics, cloud account, server, broad storage permission, or automatic syncing. File access is limited to files you choose through the system picker.
- Import limit: 25 MB. UTF-8 and Windows-1252 text are supported; save UTF-16 CSV files as UTF-8 first.
- To update the installed APK without uninstalling, keep the same signing key and application ID. Back up the debug keystore on your build machine, or create a release signing key for durable distribution. Builds from different computers/CI runs may use different debug keys. Export before changing installation/signing setup.

SAMPLE DATA
sample-products.csv is provided for a first test. Try adding, editing, deleting and undoing, exporting, then closing/reopening the app before loading the real shop CSV. This app is a manual mobile database; it does not update your till/POS database automatically.

VERIFICATION
- Web application JavaScript syntax checked; product saving and persistence verified in browser during development.
- Java CSV parser compiled/tested for BOM, quoted commas/quotes, multiline fields, semicolon CSV, leading zeros, malformed quotes, and export/import round trip.
- Android UI, SQLite integration, APK build, and real phone behavior require validation after building. No APK is claimed to be supplied or tested.
