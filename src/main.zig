const game = @import("game.zig");
const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

//----- Globals ---------------------------------------------------------------
var Game: game.Game = undefined;

export fn start() void {
    Game.reset();
}

export fn update() void {
    Game.draw();
}
