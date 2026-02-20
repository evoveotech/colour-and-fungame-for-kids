# Fonts Directory

## VAG Rounded Next Shine Font

To use the VAG Rounded Next Shine font in this app, please follow these steps:

1. Download the font files from Canva or your font source
2. Place the following files in this `fonts/` directory:
   - `VAGRoundedNextShine-Regular.ttf`
   - `VAGRoundedNextShine-Bold.ttf`

3. **Uncomment the font configuration in `pubspec.yaml`:**
   - Open `pubspec.yaml`
   - Find the commented `fonts:` section
   - Uncomment it (remove the `#` symbols)

4. After adding the font files and uncommenting, run:
```bash
flutter pub get
```

**Note:** Currently, the font configuration is commented out in `pubspec.yaml` to prevent errors. The app will use a fallback font until you add the font files and uncomment the configuration.

If the font files are not available, the app will automatically fall back to the default system font.
