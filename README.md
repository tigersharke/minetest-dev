*NOTE* minetest has been renamed to luanti.
Due to the changes necessary to continue develop[ment as luanti, this repo will end with the present commit. Further commits to new luanti-dev will be at https://github.com/tigersharke/luanti-dev
----

This repo is intended to provide the contents of a FreeBSD ports tree leaf: /usr/ports/games/minetest-dev so that those who desire may obtain and build their own.  This will follow the github repo with updates as frequent as I am able, tied to commits there.  My commits to be ONE day behind in order to avoid multiple commits of the same date.

Minetest now uses its own fork of irrlicht, but it has been folded into the minetest hierarchy in the irr directory.  The irrlicht-minetest repo is effectively shutdown, https://github.com/tigersharke/irrlicht-minetest but remains for old builds.

Useful for servers which disable the minimap, minetestmapper (https://github.com/tigersharke/minetestmapper-dev) can convert the world database into a graphical representation for an overhead map. The map would then be viewed as a large picture in an image viewer. This project has infrequent updates and could be installed via standard FreeBSD ports though I may notice upstream commits sooner.

Related but not required, although in situations where a server op chooses another texture for a NodeCore game, it may be a quick/dirty solution, the everywheres_nc texture pack repo: https://github.com/tigersharke/everywheres_nc
