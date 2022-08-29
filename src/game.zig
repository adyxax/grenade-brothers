const std = @import("std");
const spoon = @import("spoon");

const ball = @import("ball.zig");
const brothers = @import("brothers.zig");
const playfield = @import("playfield.zig");

pub const Game = struct {
    ball: ball.Ball = undefined,
    brothers: [2]brothers.Brother = undefined,
    side: brothers.Side = undefined,
    pub fn draw(self: Game, rc: *spoon.Term.RenderContext) !void {
        try playfield.draw(rc);
        try self.brothers[0].draw(rc);
        try self.brothers[1].draw(rc);
        try self.ball.draw(rc);
        var score: [1]u8 = undefined;
        try rc.moveCursorTo(1, 3);
        score[0] = '0' + self.brothers[0].score;
        _ = try rc.buffer.writer().write(score[0..]);
        try rc.moveCursorTo(1, 76);
        score[0] = '0' + self.brothers[1].score;
        _ = try rc.buffer.writer().write(score[0..]);
    }
    pub fn moveJump(self: *Game, side: brothers.Side) void {
        self.brothers[@enumToInt(side)].moveJump();
    }
    pub fn moveLeft(self: *Game, side: brothers.Side) void {
        self.brothers[@enumToInt(side)].moveLeft();
    }
    pub fn moveRight(self: *Game, side: brothers.Side) void {
        self.brothers[@enumToInt(side)].moveRight();
    }
    pub fn reset(self: *Game, side: brothers.Side) void {
        self.side = side;
        self.brothers[0].reset(.left);
        self.brothers[1].reset(.right);
        self.resetRound();
    }
    pub fn resetRound(self: *Game) void {
        self.ball.reset(.left);
        self.brothers[0].resetRound();
        self.brothers[1].resetRound();
    }
    pub fn step(self: *Game) void {
        self.ball.step();
        self.brothers[0].step(&self.ball);
        self.brothers[1].step(&self.ball);
    }
};
