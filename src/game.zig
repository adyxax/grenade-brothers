const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

const ball = @import("ball.zig");
const brothers = @import("brothers.zig");

pub const Game = struct {
    ball: ball.Ball = undefined,
    brothers: [2]brothers.Brother = undefined,
    playerSide: utils.side = undefined,
    pub fn draw(self: *Game) void {
        self.ball.draw();
        self.brothers[0].draw();
        self.brothers[1].draw();
        // draw the net
        w4.DRAW_COLORS.* = 0x42;
        w4.rect(78, 100, 4, 61);
    }
    pub fn reset(self: *Game) void {
        self.brothers[0].reset(.left);
        self.brothers[1].reset(.right);
        self.ball.resetRound(.left);
        self.brothers[0].resetRound();
        self.brothers[1].resetRound();
    }
};
