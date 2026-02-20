# Kids Colouring Game – TinyMinds

A simple colouring game for kids: templates, brush, pencil, eraser, colours, undo/redo, save & share — Bimi Boo style home screen.

## Features

- **Home screen** – Category grid (Animals, Dinosaurs, Princess, Transport, Sea, Robots, Aliens, Christmas, Nature, Food, Fantasy)
- **Templates** – Per category 6 templates (add more in `lib/models/template.dart` and drop PNGs in `assets/templates/<category>/`)
- **Colouring canvas** – Brush, Pencil, Eraser, 15‑colour palette, brush size slider
- **Undo / Redo** – App bar buttons
- **Save** – Saves to device gallery
- **Share** – Share artwork via system share sheet

## Run

```bash
flutter pub get
flutter run
```

## Adding your own templates & category images

- **Templates (colouring pages):** Put line-art PNGs in **`assets/images/<category>/`** with names **`1.png`, `2.png`, … `12.png`**.  
  Example: `assets/images/animals/1.png`, `assets/images/animals/2.png`, …  
  Categories: `animals`, `dinosaurs`, `food`, `sports`, `places`, `princess`, `transport`, `sea`, `robots`, `aliens`, `christmas`, `nature`, `fantasy`.

- **Home screen category card image:** For each category you can add **`cover.png`** in the same folder (e.g. `assets/images/animals/cover.png`).  
  If `cover.png` is missing, the app shows an icon for that category.

- **Home screen background:** Put your home background image in **`assets/images/background/home.png`**.  
  The app uses it as full-screen background on the home screen (fallback: green–blue gradient).  
  Game runs in **landscape only**.

## Project structure

```
lib/
  main.dart              # Entry, routes
  models/
    category.dart        # Home categories
    template.dart        # Template list per category
    stroke.dart          # Drawing stroke model
  screens/
    home_screen.dart     # Bimi Boo style home
    template_screen.dart # Grid of templates
    coloring_screen.dart # Canvas + tools + save/share
assets/
  images/                # Optional: logo.png for home
  templates/
    animals/, dinosaurs/, ...  # template_0.png, template_1.png, ...
```

## Tech

- Flutter (Dart), Material 3
- Packages: `path_provider`, `share_plus`, `image_gallery_saver`
