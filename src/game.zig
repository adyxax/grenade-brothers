const std = @import("std");
const spoon = @import("spoon");

const brothers = @import("brothers.zig");
const playfield = @import("playfield.zig");

pub const Game = struct {
    brothers: [2]brothers.Brother = undefined,
    side: brothers.Side = undefined,
    pub fn draw(self: Game, rc: *spoon.Term.RenderContext) !void {
        try playfield.draw(rc);
        try self.brothers[0].draw(rc);
        try self.brothers[1].draw(rc);
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
        self.resetRound();
    }
    pub fn resetRound(self: *Game) void {
        self.brothers[0].reset(.left);
        self.brothers[1].reset(.right);
    }
    pub fn step(self: *Game) void {
        self.brothers[0].step();
        self.brothers[1].step();
    }
};
