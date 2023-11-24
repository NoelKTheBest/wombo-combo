# wombo-combo

All finisher moves will end a combo. Combos themselves end once the player has hit an arbitrary
limit on attacks such as 50. Assuming the threshold is 50, all finishers will add +50 to a
variable that holds the combo value. Maybe I'll let the player increase this a bit. Normal
attacks will add anywhere from +1 to +10. As long as the threshold is not reached or the player
doesn't stop the combo, then we will keep going back and forth between light and heavy attacks.

When I was trying to setup this system using branching paths, I thought of ideas like alternate
paths, and branch jumping. The idea behind these is that I felt that we needed to give players
something to think about when playing instead of mindlessly mashing buttons.

'Branch jumping' is sort of built into the spiderweb setup because you can just jump around
through all the available attacks depending on what button is pressed and choose a different
tactic if one happens to not work well.

Alternate branches were supposed to be a way to change up strategy slightly by going down a
hidden branch where the attacks you performed were related to the original branch of attacks
but not completely identical attacks.

The concentric circles setup basically throws all of that away.

## Rules

This system still must abide by the rules I have set:

1. All buttons that map to an attack needs to transition to an attack when pressed or none of them can.
2. There will still only be one combo at a time.
3. There will still only be one button/input for one attack.

There is more to think about when designing the concentric circles, but for now I know what I
need to do to get the basic setup up and running.

## Input

When the input detection reaches the outer ring of the web, we can allow it to go back or move to the
left or right if and only if the combo limit hasn't surpassed an unchanging arbitrary value.

I want to be able to allow for vastly different playstyles and include some accessibility options,
so I'm thinking of ways to cater to a wide audience with how I will setup the input system.

For example I could do the following:

- Count multiple button presses as 1 input and change the third rule to input any input or combination
  of inputs
- If we want to limit the amount of buttons a player has to use to like 1, we could use timing in our
  string of inputs that can count as one
- Input building
