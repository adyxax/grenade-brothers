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
        self.brothers[0].draw();
        self.brothers[1].draw();
        self.ball.draw();
        // draw the net
        w4.DRAW_COLORS.* = 0x42;
        w4.rect(78, 100, 4, 61);
        // Did someone win?
        if (self.ball.y >= 160 - ball.ball_height) {
            if (self.ball.x >= 80) {
                w4.text("Scored!", 8, 64);
            } else {
                w4.text("Scored!", 160 - 56 - 8, 64);
            }
        }
    }
    pub fn reset(self: *Game) void {
        self.brothers[0].reset(.left);
        self.brothers[1].reset(.right);
        self.resetRound();
    }
    pub fn resetRound(self: *Game) void {
        if ((self.brothers[0].score + self.brothers[1].score) % 2 == 0) {
            self.ball.resetRound(.left);
        } else {
            self.ball.resetRound(.right);
        }
        self.brothers[0].resetRound();
        self.brothers[1].resetRound();
    }
    pub fn update(self: *Game) bool {
        self.gamepads[0].update(w4.GAMEPAD1.*);
        self.gamepads[1].update(w4.GAMEPAD2.*);
        self.brothers[0].update(self.gamepads[0]);
        self.brothers[1].update(self.gamepads[1]);
        const finished = self.ball.update();
        self.brothers[0].collide(&self.ball);
        self.brothers[1].collide(&self.ball);
        if (finished) |side| {
            if (side == .left) {
                self.brothers[1].score += 1;
            } else {
                self.brothers[0].score += 1;
            }
            return true;
        }
        return false;
    }
};
