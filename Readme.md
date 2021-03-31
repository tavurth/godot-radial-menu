# Table of Contents

1.  [Godot Radial Menu](#orge52b878)
    1.  [Setup](#orgc054810)
    2.  [Supported signals](#org960ab2a)
    3.  [Supported controls](#supported-controls)
        1.  [Center Node](#org1a6d789)
        2.  [Width max](#org89f2a80)
        3.  [Width min](#orgd32618a)
        4.  [Cursor size](#orgd86403c)
        5.  [Cursor deg](#org876eac5)
        6.  [Color BG](#orgd490d81)
        7.  [Color FG](#orgcb13d87)

<a id="orge52b878"></a>

# Godot Radial Menu

I created this Radial Menu as an addon for a few of my projects.

The rendering of the menu is primarily done through shader code and so should be pretty performant.

![img](./ExampleRadial/Example.gif "img")

<a id="orgc054810"></a>

## Setup

![img](./ExampleRadial/NodeSetup.png "img")

```gdscript
func _ready():
    $RadialMenu.connect("selected", self, "_on_selected")

func _input(event: InputEvent):
    if event is InputEventScreenTouch:
        $RadialMenu.set_visible(event.pressed)

func _on_selected(child: Node):
    prints("Child was selected:", child)
```

<a id="org960ab2a"></a>

## Supported signals

`hovered(child)` Emitted when a button or child is hovered

`selected(child)` Emitted when a button or child is selected

<a id="supported-controls"></a>

## Supported controls

![img](./ExampleRadial/Controls.png "img")

<a id="org1a6d789"></a>

### Center Node

`set_center_node(Node)`

Controls display in center of the spinner

<a id="org89f2a80"></a>

### Width max

`set_width_max(Float)`

- Minimum: 0
- Maximum: 1

The outside edge size of the spinner

<a id="orgd32618a"></a>

### Width min

`set_width_min(Float)`

- Minimum: 0
- Maximum: 1

The inside edge size of the spinner

<a id="orgd86403c"></a>

### Cursor size

`set_cursor_size(Float)`

- Minimum: 0
- Maximum: +ve PI

The size of the radial arc (blue portion)

<a id="org876eac5"></a>

### Cursor deg

`set_cursor_deg(Float)`

- Minimum: -ve PI
- Maximum: +ve PI

The starting degree of the cursor (will update with mouse or touch
events)

<a id="orgd490d81"></a>

### Color BG

`set_color_bg(Color)`

Background color of the radial (supports RGBA)

<a id="orgcb13d87"></a>

### Color FG

`set_color_fg(Color)`

Foreground color of the radial (supports RGBA)
