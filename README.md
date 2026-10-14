# Shopping List+

## Features

- Shows a message when the shopping list is empty.
- Tracks item quantities, with controls to add or subtract items.
- Increases quantity instead of adding duplicate items.
- Offers Undo after deleting an item.
- Filters items by All, To buy, or Bought.
- Opens an item details screen to edit its name, note, and category.

## Screenshots

### Quantities
![Shopping list with quantities](screenshots/quantities.png)

### Undo
![Undo message after deleting an item](screenshots/undo.png)

### Bought filter
![Bought filter](screenshots/bought-filter.png)

### Item details
![Item details screen](screenshots/item-details.png)

## Think

1. **Why can deleting by index remove the wrong item when a filter is on? How did you fix it?**  
   When I use a filter, the list on screen can be in a different order from the full list. So the row number on screen might belong to a different item in the full list. I fixed this by removing the actual item and saving its original position, so Undo can put it back where it was.

2. **Why remove `final` from `name`, and why is `final` still useful?**  
   I removed `final` from the name because I need to be able to change it on the details screen. I would still use `final` for values that should stay the same after they are first set, because it helps prevent accidental changes.

3. **Why was a hot restart needed after adding `quantity` to `Item`?**  
   Hot reload kept the items that were already in memory, and those items were made before I added the quantity field. I needed a hot restart so the app could create the items again with their starting quantity.

4. **Why did the list need `setState` after returning from the details screen?**  
   Editing the item changed its values, but Flutter did not know that it needed to refresh the list. I used `setState` when I returned from the details screen, which made the updated name, note, and category show up.