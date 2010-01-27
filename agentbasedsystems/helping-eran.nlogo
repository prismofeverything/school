Hey man!  Sorry it took a second, long weekend...

Aha, so in the firefly example it just checks against one color, but in yours it needs to check against all possible colors, and see which one has the most.  To start:

    turtles in-radius 3

give you a list.  This list stands for a group of things, a collection, and you can do certain kinds of things to all lists.

    [ color ] of turtles in-radius 3

uses the "of" operator to translate the list of turtles into the list of the corresponding colors for each turtle.  Now that we have the list of colors for each turtle, we need to count how many times each color appears in the list.  

    foreach [ color ] of turtles in-radius 3 [ count-color ? ] 

The "foreach" operator takes a the list of turtles and applies the last block [ count-color ? ] to each one, with the color substituted in for the "?".  Now we need the count-color function.  In order to do this, we need a table.  A table is another kind of computational collection, like a list, but this one associates one kind of thing to another.  In this case, we need a table to associate each color to the number of times that color appears.  To set this all up, include the table extension by putting this at the top of your procedures file:

    extensions [ table ]

Then, we create a table with "let" and pass it into the "count-color" procedure:

    let colors table:make
    foreach [ color ] of turtles in-radius 3 [ count-color colors ? ] 

To define count-color:

    to count-color [ colors key ]
        if not table:has-key? colors key [ table:put colors key 0 ] 
        table:put colors key (table:get colors key + 1)
    end

It takes the table and the color to count.  The way tables work is that you put things in with "table:put table-to-put-things-in key-to-look-up-by-later-with value-that-will-come-out-when-gotten-with-the-key".  Then you get things back out of the table with "table:get table-to-get-things-out-of key-that-should-be-in-the-table".  If you try to "table:get" something that was never "table:put", the program will error.  So you have to ask first if the table has the key with "table:has-key? table-that-may-or-may-not-contain-the-key key-the-table-may-or-may-not-contain".  The first line sets the entry for that color to zero if it hasn't been seen before, and the second line adds one to whatever the value was before.  So each time a color is seen, its corresponding entry in the table will be increased by one.  Now after calling this function with every color, we will have a table that maps each color to the number of times it appears.  

We can do a lot of things with this table, but for now, let's just find the one with the highest count.  We need two more variables, "highest-color" and "highest-count".

    let colors table:make
    let highest-color color 
    let highest-count 0

    foreach [ color ] of turtles in-radius 3 [ count-color colors ? ] 
    foreach table:keys colors [
        if table:get colors ? > highest-count [
            set highest-color ?
            set highest-count table:get colors ?
        ]
    ]

After all of this, "highest-color" will hold the color that appears inside radius 3 for this turtle the most times.  To finish everything off, you can make a procedure for this, so that you can call it from other procedures.  Since you get a value out of it, you want to make this procedure a "reporter" (netlogo's term for a procedure that returns a value.  usually procedures are called "functions" too, but that is another story).  Also, parameterize radius so it can be things other than 3.

    to-report color-that-appears-the-most-times [radius]
        let colors table:make
        let highest-color color 
        let highest-count 0
    
        foreach [ color ] of turtles in-radius radius [ count-color colors ? ] 
        foreach table:keys colors [
            if table:get colors ? > highest-count [
                set highest-color ?
                set highest-count table:get colors ?
            ]
        ]
    
        report highest-color
    end

If you want to do something with the number of times that color appeared, try this at the end:

        report [ highest-color highest-count ]

Then you could make the effect stronger if more of them are around, etc....  

As you can see, you can basically do anything you can imagine.  I spun all of this out here, so it is untested.  Let me know if it actually works.

- R
