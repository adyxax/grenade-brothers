const ball = @import("ball.zig");
const brothers = @import("brothers.zig");
const inputs = @import("inputs.zig");
const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

pub const Game = struct {
    ball: ball.Ball = undefined,
    brothers: [2]brothers.Brother = undefined,
    gamepads: [4]inputs.Gamepad = undefined,
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
        self.resetRound();
    }
    pub fn resetRound(self: *Game) void {
        self.ball.resetRound(.left);
        self.brothers[0].resetRound();
        self.brothers[1].resetRound();
    }
    pub fn update(self: *Game) void {
        self.gamepads[0].update(w4.GAMEPAD1.*);
        self.gamepads[1].update(w4.GAMEPAD2.*);
        self.brothers[0].update(self.gamepads[0]);
        self.brothers[1].update(self.gamepads[1]);
    }
};
