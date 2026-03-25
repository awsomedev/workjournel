# Design System Strategy: The Neon Grid

## 1. Overview & Creative North Star: "The Kinetic Curator"
This design system is built for high-energy, high-velocity digital experiences. Our Creative North Star is **"The Kinetic Curator"**—a philosophy that blends the structural efficiency of a Bento Box with the electric pulse of a late-night metropolis. 

We break the "template" look by rejecting the rigid, uniform grid. Instead, we use **Intentional Asymmetry**. Larger "Hero" modules should sit adjacent to clusters of smaller "Micro-widgets," creating a visual rhythm that feels alive. We utilize the deep black background (`#000000`) not as a void, but as a stage for high-contrast, glowing elements that feel like they are floating in three-dimensional space.

---

## 2. Colors: High-Voltage Contrast
The color palette is designed to vibrate against the `surface_container_lowest`.

*   **Primary (`#bcff5f`):** The "Lime Signal." Use this for primary actions and to draw the eye to critical data points.
*   **Secondary (`#00fbfb`):** The "Cyan Pulse." Reserved for accents, highlights, and secondary interactive states to provide a high-tech, neon aesthetic.
*   **Neutral Tones:** We use `surface_variant` (#262626) and `on_surface_variant` (#ababab) to provide structure without the harshness of pure white or mid-grey.

### The "No-Line" Rule
**Explicit Instruction:** Do not use 1px solid borders to section off content. 
Boundaries must be defined through background color shifts. A module (Bento box) should be defined by its shift from `surface` (#0e0e0e) to `surface_container` (#191919) or `surface_container_high` (#1f1f1f). Let the tonal change do the heavy lifting.

### The "Glass & Gradient" Rule
To elevate the UI from "flat" to "premium," main CTAs and "Hero" Bento boxes should utilize a subtle linear gradient from `primary` (#bcff5f) to `primary_container` (#a2f31f). For floating modals, use a backdrop-blur (12px–20px) combined with a 40% opacity `surface_container_highest` to create a "Frosted Tech" look.

---

## 3. Typography: Editorial Authority
We utilize two high-performance sans-serifs to establish a hierarchy that feels both functional and "street-style" editorial.

*   **Headlines & Display:** **Plus Jakarta Sans** is our workhorse for impact. Use `display-lg` (3.5rem) with tight tracking (-0.02em) to create a bold, "in-your-face" brand presence.
*   **Utility & Labels:** **Lexend** is used for `label-md` and `label-sm`. Its geometric clarity ensures that even at small sizes (0.6875rem), high-tech data points remain legible.
*   **Hierarchy Note:** Always pair a `display-sm` headline in `primary` color with `body-md` in `on_surface_variant` to create a sophisticated, high-contrast "Dark Mode Editorial" feel.

---

## 4. Elevation & Depth: Tonal Layering
In this system, depth is a product of light and layering, not drop shadows.

*   **The Layering Principle:** Stack your containers.
    *   *Level 0:* `surface_container_lowest` (#000000) - The Base Canvas.
    *   *Level 1:* `surface_container` (#191919) - The Main Bento Grid.
    *   *Level 2:* `surface_container_highest` (#262626) - Floating Widgets or Active States.
*   **Ambient Glows:** Instead of grey shadows, use a `primary_dim` (#95e400) glow for active elements. Set the blur to 24px and opacity to 15% to mimic a neon tube's light spill.
*   **The "Ghost Border":** If a container requires more definition against a dark background, use the `outline_variant` (#484848) at **15% opacity**. This creates a "barely there" edge that feels expensive and intentional.

---

## 5. Components: The Bento Toolkit

### Buttons
*   **Primary:** Filled with `primary` (#bcff5f), text in `on_primary` (#3d6100). Shape: `full` (9999px) for a sleek, pill-like feel.
*   **Secondary:** Ghost style. No fill. `Ghost Border` (outline-variant at 20%) with text in `secondary` (#00fbfb).
*   **States:** On hover, apply a 20px blur glow using the `surface_tint`.

### Bento Cards (The Core Component)
*   **Styling:** Use `md` (1.5rem) or `lg` (2rem) corner rounding. 
*   **Spacing:** Content inside cards should follow the `6` (2rem) spacing token for generous, "breathable" padding.
*   **No Dividers:** Never use a line to separate content within a card. Use a `1.5` (0.5rem) vertical space or a slight background tint change to `surface_bright` (#2c2c2c).

### Chips & Tags
*   **Action Chips:** High-energy `secondary_container` (#006a6a) backgrounds with `on_secondary` (#005c5c) text. Use `full` rounding.

### Input Fields
*   **Style:** Background set to `surface_container_low`. No bottom line.
*   **Focus State:** The border transitions to a 1px `primary` glow. The label should float and scale to `label-sm` in `secondary` color.

---

## 6. Do's and Don'ts

### Do
*   **DO** mix-and-match Bento box sizes (1x1, 2x1, 2x2) to create a dynamic visual "mosaic."
*   **DO** use `primary` sparingly for "moments of delight"—an icon, a sparkline, or a single word in a headline.
*   **DO** use `secondary` (Cyan) for data visualizations (graphs/progress bars) to differentiate from navigational actions.

### Don't
*   **DON'T** use 100% white (#ffffff) for long-form body text; use `on_surface_variant` (#ababab) to reduce eye strain on the deep black background.
*   **DON'T** use traditional drop shadows. If it doesn't "glow," it shouldn't have a shadow.
*   **DON'T** use sharp corners. Every interactive element must have at least an `sm` (0.5rem) radius to maintain the "fun/modern" personality.