* Make all calls to outside variables and functions localized at the top of the files.
* If Vector() is a C++ function, maybe just make it a Lua function. Or maybe add local Vector = Vector?


# Projectile path table generator

So right now I've come up with these properties for projectiles, including regular particles:
1. The path of the projectile that's a table of offsets for each frame.
2. Looping the path infinitely and camera tracking flags.
3. A "child particles" table that is optional, which'll hold information about when it should spawn those children. Think after 3 seconds have passed/every 5 seconds/when the projectile has been destroyed/when an enemy is within 100 pixels/when it's within 100 pixels of ground, etc.
4. what I mean by seeing is allowing certain projectiles to sense actors and get a vector and distance allowing for said microturrets or proximity fuzed rounds, and proabbly more I'm not thinking

Is "sticky" an INI property? If so, why does the nailer not use it? Are there currently other ways to stick projectiles than just teleporting it to the enemy every frame?