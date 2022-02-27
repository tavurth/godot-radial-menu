# Table of Contents

1.  [Godot Radial Menu](#org654cb69)
    1.  [Setup](#org2212cac)
    2.  [Supported signals](#org400324d)
    3.  [Supported controls](#supported-controls)
        1.  [Center Node](#orged0e028)
        2.  [Width max](#org4852680)
        3.  [Width min](#orgb230a63)
        4.  [Cursor size](#orgf753784)
        5.  [Cursor deg](#orge39ffb3)
        6.  [Color BG](#orgd8ac455)
        7.  [Color FG](#org4c1fc31)
        8.  [Bevel Enabled](#bevel-enabled)
        9.  [Bevel Color](#bevel-color)
        10. [Bevel Width](#bevel-width)
        11. [Modulate Enabled](#modulate-enabled)
        12. [Modulate Color](#modulate-color)
        13. [Modulate Width](#modulate-width)

<a id="org654cb69"></a>

# Godot Radial Menu

[![img](https://awesome.re/mentioned-badge.svg)](https://github.com/godotengine/awesome-godot)
![img](https://img.shields.io/github/license/tavurth/godot-radial-menu.svg?)
![img](https://img.shields.io/github/repo-size/tavurth/godot-radial-menu.svg)
![img](https://img.shields.io/github/languages/code-size/tavurth/godot-radial-menu.svg)

I created this Radial Menu as an addon for a few of my projects.

The rendering of the menu is primarily done through shader code and so should be pretty performant.

https://user-images.githubusercontent.com/100964/155878180-1aabfeb7-f246-46c4-b6a6-e60346d8279c.mov


<a id="org2212cac"></a>

## Setup

![img](./ExampleRadial/NodeSetup.png "img")

    func _ready():
        $RadialMenu.connect("selected", self, "_on_selected")

    func _input(event: InputEvent):
        if event is InputEventScreenTouch:
            $RadialMenu.set_visible(event.pressed)

    func _on_selected(child: Node):
        prints("Child was selected:", child)

<a id="org400324d"></a>

## Supported signals

`hovered(child)` Emitted when a button or child is hovered

`selected(child)` Emitted when a button or child is selected

<a id="supported-controls"></a>

## Supported controls

![img](./ExampleRadial/Controls.png "img")

<a id="orged0e028"></a>

### Center Node

`set_center_node(Node)`

Controls display in center of the spinner

<a id="org4852680"></a>

### Width max

`set_width_max(Float)`

- Minimum: 0
- Maximum: 1

The outside edge size of the spinner

<a id="orgb230a63"></a>

### Width min

`set_width_min(Float)`

- Minimum: 0
- Maximum: 1

The inside edge size of the spinner

<a id="orgf753784"></a>

### Cursor size

`set_cursor_size(Float)`

- Minimum: 0
- Maximum: +ve PI

The size of the radial arc (blue portion)

<a id="orge39ffb3"></a>

### Cursor deg

`set_cursor_deg(Float)`

- Minimum: -ve PI
- Maximum: +ve PI

The starting degree of the cursor (will update with mouse or touch
events)

<a id="orgd8ac455"></a>

### Color BG

`set_color_bg(Color)`

Background color of the radial (supports RGBA)

<a id="org4c1fc31"></a>

### Color FG

`set_color_fg(Color)`

Foreground color of the radial (supports RGBA)

<a id="bevel-enabled"></a>

### Bevel Enabled

`set_bevel_enabled(bool)`

Should a bevel be present on the edges of the modal

<a id="bevel-color"></a>

### Bevel Color

`set_bevel_color(Color)`

What color should the bevel be (if present)

<a id="bevel-width"></a>

### Bevel Width

`set_bevel_width(float)`

What should the width of the bevel be (if present)

<a id="modulate-enabled"></a>

### Modulate enabled

`set_modulate_enabled(bool)`

If enabled, buttons will be automatically modulated to the colors selected when hovered and unhovered

<a id="modulate-hover"></a>

### Modulate hover

`set_modulate_hover(Color)`

Color modulation to be applied to each button (or control) when it's hovered.
This is only applied i `modulate_enabled` is true

<a id="modulate-default"></a>

### Modulate default

`set_modulate_default(Color)`

Color modulation to be applied to each button (or control) in it's default state.
This is only applied i `modulate_enabled` is true

## Support

<a href="https://www.buymeacoffee.com/tavurth" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
