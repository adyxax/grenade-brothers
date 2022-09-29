const game = @import("game.zig");
const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

//----- Globals ---------------------------------------------------------------
var Game: game.Game = undefined;
var wait_before_new_round: u8 = 0;

export fn start() void {
    Game.reset();
}

export fn update() void {
    if (wait_before_new_round == 0) {
        const finished = Game.update();
        if (finished) {
            wait_before_new_round = 60;
        }
    } else {
        wait_before_new_round -= 1;
        if (wait_before_new_round == 0) {
            Game.resetRound();
        }
    }
    Game.draw();
}
